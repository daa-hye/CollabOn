//
//  SignUpViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/3/24.
//

import UIKit
import RxSwift
import RxCocoa

extension SignUpViewController: InputTextFieldDelegate {
    func anyImplement(_ view: InputTextField) {
        switch view {
        case emailTextField:
            break
        case phoneTextField:
            break
        default:
            break
        }
    }
}

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
            .withLatestFrom(emailTextField.text)
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)

        signUpButton.rx.tap
            .bind(to: viewModel.input.signUpButtonDidTap)
            .disposed(by: disposeBag)

        Observable.combineLatest(emailTextField.isEmpty, nicknameTextField.isEmpty, passwordTextField.isEmpty, checkPasswordTextField.isEmpty)
            .map { !$0 && !$1 && !$2 && !$3 }
            .asDriver(onErrorJustReturn: true)
            .drive(signUpButton.rx.isEnabled)
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

    }

    override func configHierarchy() {

        //view.addSubview(scrollView)
        //scrollView.addSubview(contentView)
        view.addSubview(contentView)
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

//        scrollView.snp.makeConstraints {
//            $0.top.horizontalEdges.equalToSuperview()
//            $0.bottom.equalTo(buttonView.snp.top)
//        }

        contentView.snp.makeConstraints {
//            $0.edges.equalTo(scrollView.contentLayoutGuide)
//            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(buttonView.snp.top)
        }

        emailTextField.snp.makeConstraints {
            $0.width.equalTo(233)
        }

        emailCheckButton.snp.makeConstraints {
            $0.width.equalTo(100)
        }

        inputStackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(24)
        }

    }

    override func setUIProperties() {

//        let contentInset = UIEdgeInsets.zero
//        scrollView.contentInset = contentInset
//        scrollView.scrollIndicatorInsets = contentInset
//        scrollView.bounces = false
//        scrollView.alwaysBounceHorizontal = false

        inputStackView.axis = .vertical
        inputStackView.spacing = 24

        emailStackView.axis = .horizontal
        emailStackView.spacing = 12
        emailStackView.alignment = .lastBaseline

        emailTextField.setText(label: String(localized: "이메일"), placeHolder: String(localized: "이메일을 입력하세요"))
        emailTextField.setKeyboardType(.emailAddress)
        nicknameTextField.setText(label: String(localized: "닉네임"), placeHolder: String(localized: "닉네임을 입력하세요"))
        phoneTextField.setText(label: String(localized: "연락처"), placeHolder: String(localized: "연락처를 입력하세요"))
        phoneTextField.setKeyboardType(.numberPad)
        passwordTextField.setText(label: String(localized: "비밀번호"), placeHolder: String(localized: "비밀번호를 입력하세요"))
        passwordTextField.setTextContentType(.password)
        passwordTextField.setSecure()
        checkPasswordTextField.setText(label: String(localized: "비밀번호 확인"), placeHolder: String(localized: "비밀번호를 한 번 더 입력하세요"))
        checkPasswordTextField.setTextContentType(.password)
        checkPasswordTextField.setSecure()

    }

}

extension SignUpViewController {

    private func setNavItem() {

        navigationController?.navigationBar.backgroundColor = .backgroundSecondary
        navigationItem.title = String(localized: "회원가입")

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
        dismiss(animated: true)
    }

}
