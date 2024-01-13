//
//  AuthSheetViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/3/24.
//

import UIKit
import AuthenticationServices
import RxSwift
import RxCocoa

final class AuthSheetViewController: BaseViewController {

    private let appleLoginButton = SocialLoginButton(type: .apple)
    private let kakaoLoginButton = SocialLoginButton(type: .kakao)
    private let emailLoginButton = PrimaryButton(title: String(localized: "이메일로 계속하기"))
    private let signUpLabel = UILabel()

    let viewModel = AuthSheetViewModel()

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func bindRx() {

        appleLoginButton.rx.tap
            .asDriver()
            .drive(onNext: {
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.email, .fullName]

                let controller = ASAuthorizationController(authorizationRequests: [request])
                controller.delegate = self
                controller.presentationContextProvider = self
                controller.performRequests()
            })
            .disposed(by: disposeBag)

        emailLoginButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.emailLoginButtonDidTap()
            })
            .disposed(by: disposeBag)

        viewModel.output.loginSucceeded
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

        signUpLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(signUpLabelDidTap))
        signUpLabel.addGestureRecognizer(tapGestureRecognizer)
    }

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

    @objc private func signUpLabelDidTap() {
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

extension AuthSheetViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension AuthSheetViewController: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:

            let email = appleIDCredential.email
            guard let token = appleIDCredential.identityToken,
                  let tokenToString = String(data: token, encoding: .utf8) else {
                print("Token error")
                return
            }
            print(email, tokenToString)
            viewModel.input.email.onNext(email)
            viewModel.input.identityToken.onNext(tokenToString)

        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //error
    }

}
