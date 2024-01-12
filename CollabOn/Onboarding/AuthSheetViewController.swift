//
//  AuthSheetViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/3/24.
//

import UIKit
import AuthenticationServices

final class AuthSheetViewController: BaseViewController {

    let appleLoginButton = SocialLoginButton(type: .apple)
    let kakaoLoginButton = SocialLoginButton(type: .kakao)
    let emailLoginButton = PrimaryButton(title: String(localized: "이메일로 계속하기"))
    let signUpLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configHierarchy() {
        view.addSubview(appleLoginButton)
        view.addSubview(kakaoLoginButton)
        view.addSubview(emailLoginButton)
        view.addSubview(signUpLabel)
    }

    override func setLayout() {
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(42)
            $0.height.equalTo(44)
            $0.horizontalEdges.equalToSuperview().inset(35)
        }

        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(35)
        }

        emailLoginButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(35)
        }

        signUpLabel.snp.makeConstraints {
            $0.top.equalTo(emailLoginButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(35)
        }
    }

    override func setUIProperties() {

        emailLoginButton.setImage(UIImage.email, for: .normal)

        let text = "또는 새롭게 회원가입하기"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: UIFont.title2, range: .init(location: 0, length: text.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.main, range: .init(location: 2, length: text.count-2))
        signUpLabel.attributedText = attributedString
        signUpLabel.textAlignment = .center

        emailLoginButton.addTarget(self, action: #selector(emailLoginButtonDidTap), for: .touchUpInside)

        signUpLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(signUpLabelDidTap))
        signUpLabel.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc
    private func emailLoginButtonDidTap() {
        guard let rootView = self.presentingViewController else { return }

        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 10
        }

        self.dismiss(animated: false) {
            rootView.present(nav, animated: true)
        }
    }

    @objc
    private func signUpLabelDidTap() {
        guard let rootView = self.presentingViewController else { return }

        let vc = SignUpViewController()
        let nav = UINavigationController(rootViewController: vc)

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 10
        }

        self.dismiss(animated: false) {
            rootView.present(nav, animated: true)
        }
    }

}
