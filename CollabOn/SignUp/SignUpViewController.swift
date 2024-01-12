//
//  SignUpViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/3/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {

    let scrollView = UIScrollView()
    let contentView = UIView()
    let inputStackView = UIStackView()
    let emailStackView = UIStackView()
    let emailCheckButton = PrimaryButton(title: "중복 확인")
    let emailTextField = InputTextField()
    let nicknameTextField = InputTextField()
    let phoneTextField = InputTextField()
    let passwordTextField = InputTextField()
    let checkPasswordTextField = InputTextField()
    let signUpButton = PrimaryButton(title: "가입하기")
    let buttonView = UIView()

    var disposeBag = DisposeBag()

    private let viewModel = SignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavItem()
    }

    override func bindRx() {

        emailTextField.isEmpty
            .asDriver(onErrorJustReturn: true)
            .map { !$0 }
            .drive(emailCheckButton.rx.isEnabled)
            .disposed(by: disposeBag)

        emailCheckButton.rx.tap
            .bind(to: viewModel.input.emailCheckButtonDidTap)
            .disposed(by: disposeBag)

        signUpButton.rx.tap
            .bind(to: viewModel.input.signUpButtonDidTap)
            .disposed(by: disposeBag)

        Observable.combineLatest(emailTextField.isEmpty, nicknameTextField.isEmpty, passwordTextField.isEmpty, checkPasswordTextField.isEmpty)
            .map { !$0 && !$1 && !$2 && !$3 }
            .asDriver(onErrorJustReturn: true)
            .drive(signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)

        emailTextField.text
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)

        nicknameTextField.text
            .bind(to: viewModel.input.nickname)
            .disposed(by: disposeBag)

        phoneTextField.text
            .bind(to: viewModel.input.phone)
            .disposed(by: disposeBag)

        passwordTextField.text
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)

        checkPasswordTextField.text
            .bind(to: viewModel.input.checkPassword)
            .disposed(by: disposeBag)

        viewModel.output.isEmailChecked
            .map {
                guard let isChecked = $0 else { return true }
                return isChecked
            }
            .bind(to: emailTextField.isValid)
            .disposed(by: disposeBag)

        viewModel.output.isNicknameValid
            .bind(to: nicknameTextField.isValid)
            .disposed(by: disposeBag)

        viewModel.output.isPhoneValid
            .bind(to: phoneTextField.isValid)
            .disposed(by: disposeBag)

        viewModel.output.isPasswordValid
            .bind(to: passwordTextField.isValid)
            .disposed(by: disposeBag)

        viewModel.output.isCheckPasswordValid
            .bind(to: checkPasswordTextField.isValid)
            .disposed(by: disposeBag)

        viewModel.output.signUpSucceeded
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                let vc = WorkspaceInitialViewController()
                let nav = UINavigationController(rootViewController: vc)
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                guard let sceneDelegate else { return }
                sceneDelegate.window?.rootViewController = nav
            })
            .disposed(by: disposeBag)

    }

    override func configHierarchy() {

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(inputStackView)
        emailStackView.addArrangedSubview(emailTextField)
        emailStackView.addArrangedSubview(emailCheckButton)
        inputStackView.addArrangedSubview(emailStackView)
        inputStackView.addArrangedSubview(nicknameTextField)
        inputStackView.addArrangedSubview(phoneTextField)
        inputStackView.addArrangedSubview(passwordTextField)
        inputStackView.addArrangedSubview(checkPasswordTextField)
        view.addSubview(buttonView)
        buttonView.addSubview(signUpButton)

    }

    override func setLayout() {

        buttonView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.height.equalTo(68)
        }

        signUpButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.verticalEdges.equalToSuperview().inset(12)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(buttonView.snp.top)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }

        emailTextField.snp.makeConstraints {
            $0.width.equalTo(233)
        }

        emailCheckButton.snp.makeConstraints {
            $0.width.equalTo(100)
        }

        inputStackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }

    }

    override func setUIProperties() {

        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        scrollView.bounces = false
        scrollView.alwaysBounceHorizontal = false

        inputStackView.axis = .vertical
        inputStackView.spacing = 24

        emailStackView.axis = .horizontal
        emailStackView.spacing = 12
        emailStackView.alignment = .lastBaseline

        emailTextField.setText(label: String(localized: "이메일"), placeHolder: String(localized: "이메일을 입력하세요"))
        emailTextField.setKeyboardType(.emailAddress)
        emailTextField.delegate = self

        nicknameTextField.setText(label: String(localized: "닉네임"), placeHolder: String(localized: "닉네임을 입력하세요"))
        nicknameTextField.delegate = self

        phoneTextField.setText(label: String(localized: "연락처"), placeHolder: String(localized: "연락처를 입력하세요"))
        phoneTextField.setKeyboardType(.numberPad)
        phoneTextField.delegate = self

        passwordTextField.setText(label: String(localized: "비밀번호"), placeHolder: String(localized: "비밀번호를 입력하세요"))
        passwordTextField.setTextContentType(.password)
        passwordTextField.setSecure()
        passwordTextField.delegate = self

        checkPasswordTextField.setText(label: String(localized: "비밀번호 확인"), placeHolder: String(localized: "비밀번호를 한 번 더 입력하세요"))
        checkPasswordTextField.setTextContentType(.password)
        checkPasswordTextField.setSecure()
        checkPasswordTextField.delegate = self

    }

}

extension SignUpViewController {

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

    @objc
    private func closeButtonDidTap() {
        guard let rootView = self.presentingViewController else { return }

        let vc = AuthSheetViewController()

        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom { _ in return 269 }]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 10
        }

        dismiss(animated: false) {
            rootView.present(vc, animated: false)
        }
    }

}

extension SignUpViewController: InputTextFieldDelegate {
    
    func setTextLimit(_ textField: InputTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case emailTextField:
            return (textField.count + range.length) < 30
        case nicknameTextField:
            return (textField.count + range.length) < 30
        case phoneTextField:
            textField.setPhoneNumberFormat()
            return (textField.count + range.length) < 13
        case passwordTextField:
            return (textField.count + range.length) < 20
        case checkPasswordTextField:
            return (textField.count + range.length) < 20
        default:
            return true
        }
    }

}
