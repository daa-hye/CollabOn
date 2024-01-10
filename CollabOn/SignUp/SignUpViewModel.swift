//
//  SignUpViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/4/24.
//

import Foundation
import RxSwift
import RegexBuilder

final class SignUpViewModel: ViewModelType {

    let input: Input
    let output: Output

    private let email = PublishSubject<String>()
    private let nickname = PublishSubject<String>()
    private let phone = PublishSubject<String>()
    private let password = PublishSubject<String>()
    private let checkPassword = PublishSubject<String>()
    //private let allInputs = PublishSubject<(email: String,nickname: String,phone: String,password: String,String)>()
    private let emailCheckButtonDidTap = PublishSubject<Void>()
    private let signUpButtonDidTap = PublishSubject<Void>()

    private let isEmailValid = BehaviorSubject(value: false)
    private let isEmailChecked = BehaviorSubject(value: false)
    private let isNicknameValid = PublishSubject<Bool>()
    private let isPhoneValid = PublishSubject<Bool>()
    private let isPasswordValid = PublishSubject<Bool>()
    private let isCheckPasswordValid = PublishSubject<Bool>()
//    private let areAllInputsValid = PublishSubject<Bool>()
    private let toastMessage = PublishSubject<String>()

    var disposeBag = DisposeBag()

    struct Input {
        let email: AnyObserver<String>
        let nickname: AnyObserver<String>
        let phone: AnyObserver<String>
        let password: AnyObserver<String>
        let checkPassword: AnyObserver<String>
        let emailCheckButtonDidTap: AnyObserver<Void>
        let signUpButtonDidTap: AnyObserver<Void>
    }

    struct Output {
        let isEmailValid: Observable<Bool>
        let isNicknameValid: Observable<Bool>
        let isPhoneValid: Observable<Bool>
        let isPasswordValid: Observable<Bool>
        let isCheckPasswordValid: Observable<Bool>
        let toastMessage: Observable<String>
    }

    init() {

        input = .init(
            email: email.asObserver(),
            nickname: nickname.asObserver(),
            phone: phone.asObserver(),
            password: password.asObserver(),
            checkPassword: checkPassword.asObserver(),
            emailCheckButtonDidTap: emailCheckButtonDidTap.asObserver(),
            signUpButtonDidTap: signUpButtonDidTap.asObserver()
        )

        output = .init(
            isEmailValid: isEmailValid.observe(on: MainScheduler.instance),
            isNicknameValid: isNicknameValid.observe(on: MainScheduler.instance),
            isPhoneValid: isPhoneValid.observe(on: MainScheduler.instance),
            isPasswordValid: isPasswordValid.observe(on: MainScheduler.instance),
            isCheckPasswordValid: isCheckPasswordValid.observe(on: MainScheduler.instance), 
            toastMessage: toastMessage.observe(on: MainScheduler.instance)
        )

        email
            .map { self.validateEmail($0) }
            .bind(to: isEmailValid)
            .disposed(by: disposeBag)

        email
            .subscribe(with: self) { owner, _ in
                owner.isEmailChecked.onNext(false)
            }
            .disposed(by: disposeBag)

        emailCheckButtonDidTap
            .withUnretained(self)
            .withLatestFrom(Observable.combineLatest(isEmailChecked, isEmailValid, email))
            .subscribe(onNext: { (isEmailChecked, isEmailValid, email) in
                guard !isEmailChecked else {
                    self.isEmailChecked.onNext(isEmailChecked)
                    return
                }
                if isEmailValid{
                    AuthService.shared.validateEmail(Email(email: email)) { result in
                        switch result {
                        case .success(let value):
                            self.isEmailChecked.onNext(value)
                            if value {
                                self.toastMessage.onNext(Toast.emailValid.message)
                                print("gooooood")
                            } else {
                                self.toastMessage.onNext(Toast.etc.message)
                            }
                        case .failure(let error):
                            switch error {
                            case .duplicateData:
                                self.toastMessage.onNext(Toast.emailDuplicated.message)
                            default:
                                self.toastMessage.onNext(Toast.etc.message)
                            }
                        }
                    }
                } else {
                    self.toastMessage.onNext(Toast.emailInvalid.message)
                }
            })
            .disposed(by: disposeBag)

        signUpButtonDidTap
            .withUnretained(self)
            .withLatestFrom(Observable.combineLatest(nickname, phone, password, checkPassword))
            .flatMapLatest { (nickname, phone, password, checkPassword) -> Observable<Bool> in
                self.isNicknameValid.onNext(self.validateNickname(nickname))
                self.isPhoneValid.onNext(self.validatePhone(phone))
                self.isPasswordValid.onNext(self.validatePassword(password))
                self.isCheckPasswordValid.onNext(self.validateCheckPassword(password, checkPassword))

                return Observable.combineLatest(self.isEmailChecked, self.isNicknameValid, self.isPhoneValid, self.isPasswordValid, self.isCheckPasswordValid)
                    .map { (isEmailChecked, isNicknameValid, isPhoneValid, isPasswordValid, isCheckPasswordValid) in
                        var validCheck = Array(repeating: false, count: 5)
                        validCheck[0] = isEmailChecked
                        validCheck[1] = isNicknameValid
                        validCheck[2] = isPhoneValid
                        validCheck[3] = isPasswordValid
                        validCheck[4] = isCheckPasswordValid

                        for index in (0..<validCheck.count) {
                            if validCheck[index] == false {
                                guard let message = Toast(rawValue: index)?.message else { break }
                                self.toastMessage.onNext(message)
                                return false
                            }
                        }
                        return true
                    }
            }
            .filter { $0 }
            .withLatestFrom(Observable.combineLatest(email, nickname, phone, password, checkPassword))
            .subscribe { (email, nickname, phone, password, checkPassword) in
                AuthService.shared.join(Join(email: email, password: password, nickname: nickname, phone: phone, deviceToken: nil)) { result in
                    switch result {
                    case .success(let value):
                        print("회원가입 완")
                    case .failure(let error):
                        switch error {
                        case .duplicateData:
                            self.toastMessage.onNext(Toast.emailDuplicated.message)
                        default:
                            self.toastMessage.onNext(Toast.etc.message)
                        }
                    }
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

extension SignUpViewModel {

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

        return email.contains(emailPattern)

    }

    private func validateNickname(_ nickname: String) -> Bool {

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

    private func validatePhone(_ phone: String) -> Bool {

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

        return password.contains(passwordPattern)

    }

    private func validateCheckPassword(_ password: String, _ check: String) -> Bool {
        return password == check
    }

}

extension SignUpViewModel {

    private enum Toast: Int {
        case emailUnchecked
        case nicknameInvalid
        case phoneInvalid
        case passwordInvalid
        case checkPasswordInvalid
        case emailInvalid
        case emailValid
        case emailDuplicated
        case etc

        var message: String {
            switch self {
            case .emailInvalid:
                String(localized: "이메일 형식이 올바르지 않습니다.")
            case .emailValid:
                String(localized: "사용 가능한 이메일입니다.")
            case .emailUnchecked:
                String(localized: "이메일 중복 확인을 진행해주세요.")
            case .nicknameInvalid:
                String(localized: "닉네임은 1글자 이상 30글자 이내로 부탁드려요.")
            case .phoneInvalid:
                String(localized: "잘못된 전화번호 형식입니다.")
            case .passwordInvalid:
                String(localized: "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요.")
            case .checkPasswordInvalid:
                String(localized: "작성하신 비밀번호가 일치하지 않습니다.")
            case .emailDuplicated:
                String(localized: "이미 가입된 회원입니다. 로그인을 진행해주세요.")
            case .etc:
                String(localized: "에러가 발생했어요. 잠시 후 다시 시도해주세요.")
            }
        }
    }

}
