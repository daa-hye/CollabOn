//
//  AuthSheetViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/13/24.
//

import Foundation
import RxSwift

final class AuthSheetViewModel: ViewModelType {

    var disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let identityToken = PublishSubject<String>()
    private let email = PublishSubject<String?>()

    private let loginSucceeded = PublishSubject<Void>()
    private let toastMeaage = PublishSubject<String>()

    struct Input {
        let identityToken: AnyObserver<String>
        let email: AnyObserver<String?>
    }

    struct Output {
        let loginSucceeded: Observable<Void>
        let toastMeaage: Observable<String>
    }

    init() {

        input = .init(
            identityToken: identityToken.asObserver(),
            email: email.asObserver()
        )

        output = .init(
            loginSucceeded: loginSucceeded.observe(on: MainScheduler.instance),
            toastMeaage: toastMeaage.observe(on: MainScheduler.instance)
        )

        Observable.zip(identityToken, email)
            .flatMapLatest { (token, email) in
                if let email = email, let nickname = email.components(separatedBy: "@").first  {
                    return AuthService.shared.appleJoin(AppleJoin(idToken: token, nickname: nickname, deviceToken: nil))
                        .asObservable()
                        .materialize()
                } else {
                    return AuthService.shared.appleLogin(AppleLogin(idToken: token, deviceToken: nil))
                        .asObservable()
                        .materialize()
                }
            }
            .subscribe(with: self) { owner, value in
                switch value {
                case .next:
                    owner.loginSucceeded.onNext(())
                case .error(let error):
                    owner.toastMeaage.onNext(Toast.loginFailed.message)
                default:
                    owner.toastMeaage.onNext(Toast.etc.message)
                }
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
