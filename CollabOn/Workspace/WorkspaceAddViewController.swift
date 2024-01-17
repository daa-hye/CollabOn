//
//  WorkspaceAddViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/17/24.
//

import UIKit
import RxSwift
import RxCocoa

class WorkspaceAddViewController: BaseViewController {

    let profileView = UIView()
    let backgroundView = UIView()
    let profileImage = UIImageView()
    let cameraImage = UIImageView()
    let nameTextField = InputTextField()
    let descriptionTextField = InputTextField()
    let buttonView = UIView()
    let confirmButton = PrimaryButton(title: String(localized: "완료"))

    let viewModel = WorkspaceAddViewModel()

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

        confirmButton.rx.tap
            .bind(to: viewModel.input.confirmButtonDidTap)
            .disposed(by: disposeBag)
    }

    override func configHierarchy() {
        view.addSubview(profileView)
        profileView.addSubview(backgroundView)
        profileView.addSubview(cameraImage)
        backgroundView.addSubview(profileImage)
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

        backgroundView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(70)
        }

        cameraImage.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.size.equalTo(24)
        }

        profileImage.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        nameTextField.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom).offset(16)
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
        backgroundView.backgroundColor = .main
        backgroundView.layer.cornerRadius = 8

        cameraImage.image = .camera
        profileImage.image = .workspace

        nameTextField.setText(label: String(localized: "워크스페이스 이름"),
                              placeHolder: String(localized: "워크스페이스 이름을 입력하세요 (필수)"))
        descriptionTextField.setText(label: String(localized: "워크스페이스 설명"),
                                     placeHolder: String(localized: "워크스페이스를 설명하세요 (옵션)"))
    }

}

extension WorkspaceAddViewController {

    private func setNavItem() {

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .backgroundSecondary
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.title = String(localized: "회원가입")

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

extension WorkspaceAddViewController: InputTextFieldDelegate {

    func setTextLimit(_ textField: InputTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTextField {
            return (textField.count + range.length) < 30
        }

        return true
    }

}
