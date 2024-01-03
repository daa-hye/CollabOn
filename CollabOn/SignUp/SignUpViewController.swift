//
//  SignUpViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/3/24.
//

import UIKit

final class SignUpViewController: BaseViewController {

    //let scrollView = UIScrollView()
    let contentView = UIView()
    let inputStackView = UIStackView()
    let emailStackView = UIStackView()
    let emailCheckButton = BaseButton(title: "중복 확인")
    let emailTextField = InputTextField()
    let nicknameTextField = InputTextField()
    let phoneTextField = InputTextField()
    let passwordTextField = InputTextField()
    let checkPasswordTextField = InputTextField()
    let signUpButton = BaseButton(title: "가입하기")

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavItem()
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
        contentView.addSubview(signUpButton)
    }

    override func setLayout() {
//        scrollView.snp.makeConstraints {
//            $0.horizontalEdges.equalToSuperview()
//        }

        contentView.snp.makeConstraints {
//            $0.edges.equalTo(scrollView.contentLayoutGuide)
//            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
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

        signUpButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
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
        nicknameTextField.setText(label: String(localized: "닉네임"), placeHolder: String(localized: "닉네임을 입력하세요"))
        phoneTextField.setText(label: String(localized: "연락처"), placeHolder: String(localized: "연락처를 입력하세요"))
        passwordTextField.setText(label: String(localized: "비밀번호"), placeHolder: String(localized: "비밀번호를 입력하세요"))
        checkPasswordTextField.setText(label: String(localized: "비밀번호"), placeHolder: String(localized: "비밀번호를 한 번 더 입력하세요"))


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
