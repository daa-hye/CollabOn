//
//  SignUpViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/4/24.
//

import Foundation
import RxSwift
import RegexBuilder

class SignUpViewModel: ViewModelType {

    let input: Input
    let output: Output

    private let email = PublishSubject<String>()
    private let nickname = PublishSubject<String>()
    private let phone = PublishSubject<String>()
    private let password = PublishSubject<String>()
    private let checkPassword = PublishSubject<String>()
    private let signUpButtonDidTap = PublishSubject<Void>()

    private let isEmailValid = BehaviorSubject(value: false)
    private let isEmailChecked = BehaviorSubject(value: false)
    private let isNicknameValid = PublishSubject<Bool>()
    private let isPhoneValid = PublishSubject<Bool>()
    private let isPasswordValid = PublishSubject<Bool>()
    private let isCheckPasswordValid = PublishSubject<Bool>()

    var disposeBag = DisposeBag()

    init() {

        input = .init(
            email: email.asObserver(),
            nickname: nickname.asObserver(),
            phone: phone.asObserver(),
            password: password.asObserver(),
            checkPassword: checkPassword.asObserver(),
            signUpButtonDidTap: signUpButtonDidTap.asObserver()
        )

        output = .init(
            isEmailValid: isEmailValid.observe(on: MainScheduler.instance),
            isNicknameValid: isNicknameValid.observe(on: MainScheduler.instance),
            isPhoneValid: isPhoneValid.observe(on: MainScheduler.instance),
            isPasswordValid: isPasswordValid.observe(on: MainScheduler.instance),
            isCheckPasswordValid: isCheckPasswordValid.observe(on: MainScheduler.instance)
        )

        email
            .map { self.emailValidation($0) }
            .bind(to: isEmailValid)
            .disposed(by: disposeBag)

        signUpButtonDidTap
            .withUnretained(self)
            .withLatestFrom(Observable.combineLatest(nickname, phone, password, checkPassword))
            .subscribe { (nickname, phone, password, checkPassword) in
                self.isNicknameValid.onNext(self.nicknameValidation(nickname))
                self.isPhoneValid.onNext(self.phoneValidation(phone))
                self.isPasswordValid.onNext(self.passwordValidation(password))
                self.isCheckPasswordValid.onNext(self.checkPasswordValidation(password, checkPassword))
            }
            .disposed(by: disposeBag)

    }

    struct Input {
        let email: AnyObserver<String>
        let nickname: AnyObserver<String>
        let phone: AnyObserver<String>
        let password: AnyObserver<String>
        let checkPassword: AnyObserver<String>
        let signUpButtonDidTap: AnyObserver<Void>
    }

    struct Output {
        let isEmailValid: Observable<Bool>
        let isNicknameValid: Observable<Bool>
        let isPhoneValid: Observable<Bool>
        let isPasswordValid: Observable<Bool>
        let isCheckPasswordValid: Observable<Bool>
    }


}

extension SignUpViewModel {

    private func emailValidation(_ email: String) -> Bool {

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

        return email.contains(emailPattern)

    }

    private func nicknameValidation(_ nickname: String) -> Bool {

        let nicknamePattern = Regex {
            Repeat(1...30) {
                CharacterClass(
                    .anyOf("._%+-"),
                    ("A"..."Z"),
                    ("0"..."9"),
                    ("a"..."z")
                )
            }
        }
        return nickname.contains(nicknamePattern)

    }

    private func phoneValidation(_ phone: String) -> Bool {

        guard phone != "" else { return true }
        let phonePattern = Regex {
            "010-"
            Repeat(3...4) {
                ("0"..."9")
            }
            "-"
            Repeat(count: 4) {
                ("0"..."9")
            }
        }
        return phone.contains(phonePattern)

    }

    private func passwordValidation(_ password: String) -> Bool {

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

        return password.contains(passwordPattern)

    }

    private func checkPasswordValidation(_ password: String, _ check: String) -> Bool {
        return password == check
    }

}
