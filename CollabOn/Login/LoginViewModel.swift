//
//  LoginViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/12/24.
//

import Foundation
import RxSwift
import RegexBuilder

class LoginViewModel: ViewModelType {

    let input: Input
    let output: Output

    private let email = PublishSubject<String>()
    private let password = PublishSubject<String>()
    private let loginButtonDidTap = PublishSubject<Void>()

    private let isEmailValid = PublishSubject<Bool>()
    private let isPasswordValid = PublishSubject<Bool>()
    private let toastMessage = PublishSubject<String>()
    private let loginSucceeded = PublishSubject<Void>()

    var disposeBag = DisposeBag()

    struct Input {
        let email: AnyObserver<String>
        let password: AnyObserver<String>
        let loginButtonDidTap: AnyObserver<Void>
    }

    struct Output {
        let isEmailValid: Observable<Bool>
        let isPasswordValid: Observable<Bool>
        let toastMessage: Observable<String>
        let loginSucceeded: Observable<Void>
    }

    init() {
        
        input = .init(
            email: email.asObserver(),
            password: password.asObserver(),
            loginButtonDidTap: loginButtonDidTap.asObserver()
        )

        output = .init(
            isEmailValid: isEmailValid.observe(on: MainScheduler.instance),
            isPasswordValid: isPasswordValid.observe(on: MainScheduler.instance),
            toastMessage: toastMessage.observe(on: MainScheduler.instance),
            loginSucceeded: loginSucceeded.observe(on: MainScheduler.instance)
        )

        loginButtonDidTap
            .withLatestFrom(Observable.combineLatest(email, password))
            .filter { self.validateLoginData(email: $0.0, password: $0.1) }
            .subscribe { (email, password) in
                
            }
            .disposed(by: disposeBag)

        toastMessage
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)

    }

}

extension LoginViewModel {

    private func validateLoginData(email: String, password: String) -> Bool {
        let isEmailValid = self.validateEmail(email)
        let isPasswordValid = self.validatePassword(password)

        let validCheck: [Bool] = [
            isEmailValid,
            isPasswordValid
        ]

        self.isEmailValid.onNext(isEmailValid)
        self.isPasswordValid.onNext(isPasswordValid)

        for index in (0..<validCheck.count) {
            if validCheck[index] == false {
                guard let message = Toast(rawValue: index)?.message else { break }
                self.toastMessage.onNext(message)
                return false
            }
        }

        return true
    }

    private func validateEmail(_ email: String) -> Bool {

        let emailPattern = Regex {
            OneOrMore {
                CharacterClass(
                    .anyOf("._%+-"),
                    ("A"..."Z"),
                    ("0"..."9"),
                    ("a"..."z")
                )
            }
            "@"
            OneOrMore {
                CharacterClass(
                    .anyOf(".-"),
                    ("A"..."Z"),
                    ("a"..."z"),
                    ("0"..."9")
                )
            }
            "."
            Repeat(2...) {
                CharacterClass(
                    ("A"..."Z"),
                    ("a"..."z")
                )
            }
        }

        return email.wholeMatch(of: emailPattern) != nil

    }

    private func validatePassword(_ password: String) -> Bool {

        let passwordPattern = Regex {
            Repeat(8...20) {
                CharacterClass(
                    .anyOf("!_@$%^&+="),
                    ("A"..."Z"),
                    ("a"..."z"),
                    ("0"..."9")
                )
            }
        }

        return password.wholeMatch(of: passwordPattern) != nil

    }


}

extension LoginViewModel {

    private enum Toast: Int {
        case emailInvalid
        case passwordInvalid

        var message: String {
            switch self {
            case .emailInvalid:
                String(localized: "이메일 형식이 올바르지 않습니다.")
            case .passwordInvalid:
                String(localized: "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 입력해주세요.")
            }
        }
    }

}
