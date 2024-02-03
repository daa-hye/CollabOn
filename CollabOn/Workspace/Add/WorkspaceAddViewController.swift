//
//  WorkspaceAddViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/17/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa
import RxGesture

final class WorkspaceAddViewController: BaseViewController {

    private let profileView = UIView()
    private let profileImage = UIImageView()
    private let cameraImage = UIImageView()
    private let nameTextField = InputTextField()
    private let descriptionTextField = InputTextField()
    private let buttonView = UIView()
    private let confirmButton = PrimaryButton(title: String(localized: "완료"))

    private let viewModel = WorkspaceAddViewModel()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavItem()
    }

    override func bindRx() {

        nameTextField.isEmpty
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(confirmButton.rx.isEnabled)
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

        confirmButton.rx.tap
            .bind(to: viewModel.input.confirmButtonDidTap)
            .disposed(by: disposeBag)

        viewModel.output.isSuccess
            .subscribe(with: self) { owner, value in
                owner.dismiss(animated: true)
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
        buttonView.addSubview(confirmButton)
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

        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.verticalEdges.equalToSuperview().inset(12)
        }

    }

    override func setUIProperties() {
        buttonView.isUserInteractionEnabled = true

        cameraImage.image = .camera
        profileImage.image = .workspace
        profileImage.layer.cornerRadius = 8
        profileImage.clipsToBounds = true

        nameTextField.setText(label: String(localized: "워크스페이스 이름"),
                              placeHolder: String(localized: "워크스페이스 이름을 입력하세요 (필수)"))
        descriptionTextField.setText(label: String(localized: "워크스페이스 설명"),
                                     placeHolder: String(localized: "워크스페이스를 설명하세요 (옵션)"))
    }

}

extension WorkspaceAddViewController {

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
        self.title = String(localized: "워크스페이스 생성")

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

extension WorkspaceAddViewController: PHPickerViewControllerDelegate {

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

extension WorkspaceAddViewController: InputTextFieldDelegate {

    func setTextLimit(_ textField: InputTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTextField {
            return (textField.count + range.length) < 30
        }

        return true
    }

}
