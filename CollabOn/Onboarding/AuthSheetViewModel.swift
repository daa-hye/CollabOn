//
//  AuthSheetViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/13/24.
//

import Foundation
import RxSwift
import KakaoSDKUser
import KakaoSDKAuth
import RxKakaoSDKUser

final class AuthSheetViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let identityToken = PublishSubject<String>()
    private let email = PublishSubject<String?>()
    private let kakaoLoginButtonDidTap = PublishSubject<Void>()

    private let loginSucceeded = PublishSubject<Void>()
    private let toastMessage = PublishSubject<String>()

    struct Input {
        let identityToken: AnyObserver<String>
        let email: AnyObserver<String?>
        let kakaoLoginButtonDidTap: AnyObserver<Void>
    }

    struct Output {
        let loginSucceeded: Observable<Void>
        let toastMessage: Observable<String>
    }

    init() {

        input = .init(
            identityToken: identityToken.asObserver(),
            email: email.asObserver(), 
            kakaoLoginButtonDidTap: kakaoLoginButtonDidTap.asObserver()
        )

        output = .init(
            loginSucceeded: loginSucceeded.observe(on: MainScheduler.instance),
            toastMessage: toastMessage.observe(on: MainScheduler.instance)
        )

        Observable.zip(identityToken, email)
            .flatMapLatest { (token, email) in
                if let email = email, let nickname = email.components(separatedBy: "@").first  {
                    return UserService.shared.appleJoin(AppleJoin(idToken: token, nickname: nickname, deviceToken: nil))
                        .asObservable()
                        .materialize()
                } else {
                    return UserService.shared.appleLogin(AppleLogin(idToken: token, deviceToken: nil))
                        .asObservable()
                        .materialize()
                }
            }
            .subscribe(with: self) { owner, event in
                switch event {
                case .next:
                    owner.loginSucceeded.onNext(())
                case .error:
                    owner.toastMessage.onNext(Toast.loginFailed.message)
                default:
                    owner.toastMessage.onNext(Toast.etc.message)
                }
            }
            .disposed(by: disposeBag)

        kakaoLoginButtonDidTap
            .flatMapLatest { _ -> Observable<OAuthToken> in
                if UserApi.isKakaoTalkLoginAvailable() {
                    return UserApi.shared.rx.loginWithKakaoTalk()
                } else {
                    return UserApi.shared.rx.loginWithKakaoAccount()
                }
            }
            .map { $0.accessToken }
            .flatMapLatest { token in
                UserService.shared.kakaoLogin(KakaoLogin(oauthToken: token, deviceToken: nil))
                    .asObservable()
                    .materialize()
            }
            .subscribe(with: self) { owner, event in
                switch event {
                case .next:
                    owner.loginSucceeded.onNext(())
                case .error:
                    owner.toastMessage.onNext(Toast.loginFailed.message)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        toastMessage
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)

    }
}

extension AuthSheetViewModel {

    private enum Toast {
        case loginFailed
        case etc

        var message: String {
            switch self {
            case .loginFailed:
                String(localized: "로그인이 실패하였습니다.")
            case .etc:
                String(localized: "에러가 발생했어요. 잠시 후 다시 시도해주세요.")
            }
        }
    }

}
