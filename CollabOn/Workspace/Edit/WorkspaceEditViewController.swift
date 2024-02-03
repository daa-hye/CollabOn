//
//  WorkspaceEditViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 2/2/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa
import RxGesture
import Kingfisher

final class WorkspaceEditViewController: BaseViewController {

    private let profileView = UIView()
    private let profileImage = UIImageView()
    private let cameraImage = UIImageView()
    private let nameTextField = InputTextField()
    private let descriptionTextField = InputTextField()
    private let buttonView = UIView()
    private let saveButton = PrimaryButton(title: String(localized: "저장"))

    private let viewModel: WorkspaceEditViewModel

    let disposeBag = DisposeBag()

    init(viewModel: WorkspaceEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        viewModel.output.name
            .subscribe(with: self) { owner, name in
                owner.nameTextField.setText(text: name)
            }
            .disposed(by: disposeBag)

        viewModel.output.description
            .subscribe(with: self) { owner, description in
                owner.descriptionTextField.setText(text: description)
            }
            .disposed(by: disposeBag)

        viewModel.output.image
            .subscribe(with: self) { owner, url in
                owner.profileImage.kf.setImage(with: url, options: [.requestModifier(ImageService.shared.getImage())])
            }
            .disposed(by: disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavItem()
    }

    override func bindRx() {

        nameTextField.isEmpty
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(saveButton.rx.isEnabled)
            .disposed(by: disposeBag)

        nameTextField.text
            .bind(to: viewModel.input.name)
            .disposed(by: disposeBag)

        descriptionTextField.text
            .bind(to: viewModel.input.description)
            .disposed(by: disposeBag)

        profileView.rx.tapGesture()
            .when(.recognized)
            .subscribe(with: self) { owner, _ in
                owner.presentPickerView()
            }
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .bind(to: viewModel.input.saveButtonDidTap)
            .disposed(by: disposeBag)

        viewModel.output.isSuccess
            .subscribe(with: self) { owner, value in
                guard let rootView = self.presentingViewController else { return }
                owner.dismiss(animated: false) {
                    rootView.showToast(message: String(localized: "워크스페이스가 편집되었습니다"), offset: 24)
                }
            }
            .disposed(by: disposeBag)

    }

    override func configHierarchy() {
        view.addSubview(profileView)
        profileView.addSubview(profileImage)
        profileView.addSubview(cameraImage)
        view.addSubview(nameTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(buttonView)
        buttonView.addSubview(saveButton)
    }

    override func setLayout() {

        profileView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.centerX.equalToSuperview().offset(7)
            $0.width.equalTo(77)
            $0.height.equalTo(75)
        }

        cameraImage.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.size.equalTo(24)
        }

        profileImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(70)
        }

        nameTextField.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        descriptionTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        buttonView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.height.equalTo(68)
        }

        saveButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.verticalEdges.equalToSuperview().inset(12)
        }

    }

    override func setUIProperties() {
        buttonView.isUserInteractionEnabled = true

        cameraImage.image = .camera
        profileImage.layer.cornerRadius = 8
        profileImage.clipsToBounds = true

        nameTextField.setText(label: String(localized: "워크스페이스 이름"),
                              placeHolder: String(localized: "워크스페이스 이름을 입력하세요 (필수)"))
        descriptionTextField.setText(label: String(localized: "워크스페이스 설명"),
                                     placeHolder: String(localized: "워크스페이스를 설명하세요 (옵션)"))
    }

}

extension WorkspaceEditViewController {

    private func presentPickerView() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1

        configuration.filter = .any(of: [.images, .depthEffectPhotos, .livePhotos])

        let picker = PHPickerViewController(configuration: configuration)
        picker.modalPresentationStyle = .fullScreen
        picker.delegate = self

        present(picker, animated: true)
    }

    private func setNavItem() {

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .backgroundSecondary
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.title = String(localized: "워크스페이스 편집")

        let closeButton = UIBarButtonItem(
            image: .close,
            style: .done,
            target: self,
            action: #selector(closeButtonDidTap)
        )
        closeButton.tintColor = .black
        navigationItem.leftBarButtonItem = closeButton
    }

    @objc private func closeButtonDidTap() {
        dismiss(animated: true)
    }



}

extension WorkspaceEditViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProvider = results.first?.itemProvider
        if let itemProvider,
           itemProvider
            .hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            itemProvider
                .loadDataRepresentation(
                    forTypeIdentifier: UTType.image.identifier,
                    completionHandler: { [weak self] data, error in
                        guard let data,
                              let image = UIImage(data: data)
                        else { return }

                        image.resizeImage(toTargetSizeMB: 1) { image in
                            guard let image = image, let data = image.jpegData(compressionQuality: 1) else { return }
                            DispatchQueue.main.async {
                                self?.profileImage.image = image
                                self?.profileImage.snp.makeConstraints {
                                    $0.edges.equalToSuperview()
                                }
                                self?.viewModel.input.image.onNext(data)
                                picker.dismiss(animated: true)
                            }
                        }
                    })
        }
    }

}

extension WorkspaceEditViewController: InputTextFieldDelegate {

    func setTextLimit(_ textField: InputTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTextField {
            return (textField.count + range.length) < 30
        }

        return true
    }

}
