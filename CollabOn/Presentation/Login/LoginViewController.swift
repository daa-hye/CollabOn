//
//  LoginViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/12/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {

    let emailTextField = InputTextField()
    let passwordTextField = InputTextField()
    let loginButton = PrimaryButton(title: "로그인")
    let buttonView = UIView()

    let viewModel = LoginViewModel()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavItem()
    }

    override func bindRx() {

        Observable.combineLatest(emailTextField.isEmpty, passwordTextField.isEmpty)
            .map { !$0 && !$1 }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        emailTextField.text
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)

        passwordTextField.text
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)

        loginButton.rx.tap
            .bind(to: viewModel.input.loginButtonDidTap)
            .disposed(by: disposeBag)

        viewModel.output.isEmailValid
            .bind(to: emailTextField.isValid)
            .disposed(by: disposeBag)

        viewModel.output.isPasswordValid
            .bind(to: passwordTextField.isValid)
            .disposed(by: disposeBag)

        viewModel.output.loginSucceeded
            .bind {
                let vc = WorkspaceInitialViewController()
                let nav = UINavigationController(rootViewController: vc)
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                guard let sceneDelegate else { return }
                sceneDelegate.window?.rootViewController = nav
            }
            .disposed(by: disposeBag)

        viewModel.output.toastMessage
            .bind(with: self) { owner, message in
                owner.showToast(message: message, constraintView: owner.buttonView, offset: 4)
            }
            .disposed(by: disposeBag)

    }

    override func configHierarchy() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(buttonView)
        buttonView.addSubview(loginButton)
    }

    override func setLayout() {
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        buttonView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.height.equalTo(68)
        }

        loginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.verticalEdges.equalToSuperview().inset(12)
        }
    }

    override func setUIProperties() {

        emailTextField.setText(label: String(localized: "이메일"), placeHolder: String(localized: "이메일을 입력하세요"))
        emailTextField.setKeyboardType(.emailAddress)
        emailTextField.delegate = self

        passwordTextField.setText(label: String(localized: "비밀번호"), placeHolder: String(localized: "비밀번호를 입력하세요"))
        passwordTextField.setTextContentType(.password)
        passwordTextField.setSecure()
        passwordTextField.delegate = self

    }

}

extension LoginViewController {

    private func setNavItem() {

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .backgroundSecondary
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.title = String(localized: "이메일 로그인")

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

extension LoginViewController: InputTextFieldDelegate {

    func setTextLimit(_ textField: InputTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case emailTextField:
            return (textField.count + range.length) < 30
        case passwordTextField:
            return (textField.count + range.length) < 20
        default:
            return true
        }
    }

}
