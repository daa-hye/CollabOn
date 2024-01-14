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

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let email = PublishSubject<String>()
    private let nickname = PublishSubject<String>()
    private let phone = PublishSubject<String>()
    private let password = PublishSubject<String>()
    private let checkPassword = PublishSubject<String>()
    private let emailCheckButtonDidTap = PublishSubject<Void>()
    private let signUpButtonDidTap = PublishSubject<Void>()

    private let isEmailValid = BehaviorSubject(value: false)
    private let isEmailChecked = BehaviorSubject<Bool?>(value: nil)
    private let isNicknameValid = PublishSubject<Bool>()
    private let isPhoneValid = PublishSubject<Bool>()
    private let isPasswordValid = PublishSubject<Bool>()
    private let isCheckPasswordValid = PublishSubject<Bool>()
    private let toastMessage = PublishSubject<String>()
    private let signUpSucceeded = PublishSubject<Void>()

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
        let isEmailChecked: Observable<Bool?>
        let isNicknameValid: Observable<Bool>
        let isPhoneValid: Observable<Bool>
        let isPasswordValid: Observable<Bool>
        let isCheckPasswordValid: Observable<Bool>
        let toastMessage: Observable<String>
        let signUpSucceeded: Observable<Void>
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
            isEmailChecked: isEmailChecked.observe(on: MainScheduler.instance),
            isNicknameValid: isNicknameValid.observe(on: MainScheduler.instance),
            isPhoneValid: isPhoneValid.observe(on: MainScheduler.instance),
            isPasswordValid: isPasswordValid.observe(on: MainScheduler.instance),
            isCheckPasswordValid: isCheckPasswordValid.observe(on: MainScheduler.instance), 
            toastMessage: toastMessage.observe(on: MainScheduler.instance),
            signUpSucceeded: signUpSucceeded.observe(on: MainScheduler.instance)
        )

        email
            .map { self.validateEmail($0) }
            .bind(to: isEmailValid)
            .disposed(by: disposeBag)

        email
            .subscribe(with: self) { owner, _ in
                owner.isEmailChecked.onNext(nil)
            }
            .disposed(by: disposeBag)

        emailCheckButtonDidTap
            .withLatestFrom(Observable.combineLatest(isEmailChecked, isEmailValid, email))
            .filter({ (isEmailChecked, isEmailValid, _) in
                if isEmailChecked == true {
                    self.toastMessage.onNext(Toast.emailValid.message)
                    return false
                }
                if isEmailValid == false {
                    self.toastMessage.onNext(Toast.emailInvalid.message)
                    return false
                }
                return true
            })
            .flatMapLatest { (isEmailChecked, isEmailValid, email: String) in
                AuthService.shared.validateEmail(Email(email: email))
                    .asObservable()
                    .materialize()
            }
            .subscribe(with: self) { owner, event in
                switch event {
                case .next:
                    owner.toastMessage.onNext(Toast.emailValid.message)
                    owner.isEmailChecked.onNext(true)
                case .error(let error):
                    switch error {
                    case EndPointError.duplicateData:
                        owner.toastMessage.onNext(Toast.emailDuplicated.message)
                    default:
                        owner.toastMessage.onNext(Toast.etc.message)
                    }
                default:
                    owner.toastMessage.onNext(Toast.etc.message)
                }
            }
            .disposed(by: disposeBag)

        signUpButtonDidTap
            .withLatestFrom(Observable.combineLatest(email, phone, nickname, password, checkPassword, isEmailChecked))
            .filter { self.validateSignUpData(email: $0.0, phone: $0.1, nickname: $0.2, password: $0.3, checkPassword: $0.4, isEmailChecked: $0.5) }
            .flatMapLatest{ (email, phone, nickname, password, checkPassword, isEmailChecked) in
                AuthService.shared.join(Join(email: email, password: password, nickname: nickname, phone: phone, deviceToken: nil))
                    .asObservable()
                    .materialize()
            }
            .subscribe(with: self) { owner, event in
                switch event {
                case .next:
                    owner.signUpSucceeded.onNext(())
                case .error(let error):
                    switch error {
                    case EndPointError.duplicateData:
                        owner.toastMessage.onNext(Toast.emailDuplicated.message)
                    default:
                        owner.toastMessage.onNext(Toast.etc.message)
                    }
                default:
                    owner.toastMessage.onNext(Toast.etc.message)
                }
            }
            .disposed(by: self.disposeBag)

        toastMessage
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)

    }

}

extension SignUpViewModel {

    private func validateSignUpData(email: String, phone: String, nickname: String, password: String, checkPassword: String, isEmailChecked: Bool?) -> Bool {
        let isNicknameValid = self.validateNickname(nickname)
        let isPhoneValid = self.validatePhone(phone)
        let isPasswordValid = self.validatePassword(password)
        let isCheckPasswordValid = self.validateCheckPassword(password, checkPassword)

        let validCheck: [Bool] = [
            isEmailChecked ?? false,
            isNicknameValid,
            isPhoneValid,
            isPasswordValid,
            isCheckPasswordValid
        ]

        if validCheck.first == false {
            self.isEmailChecked.onNext(false)
        }
        self.isNicknameValid.onNext(isNicknameValid)
        self.isPhoneValid.onNext(isPhoneValid)
        self.isPasswordValid.onNext(isPasswordValid)
        self.isCheckPasswordValid.onNext(isCheckPasswordValid)

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
                    .anyOf("._%+-"),
                    ("A"..."Z"),
                    ("0"..."9"),
                    ("a"..."z")
                )
            }
            "."
            ChoiceOf {
                "com"
                "net"
                Regex {
                    Repeat(count: 2) {
                        CharacterClass (
                            ("a"..."z"),
                            ("A"..."Z")
                        )
                    }
                    ".kr"
                }
            }
        }

        return email.wholeMatch(of: emailPattern) != nil

    }

    private func validateNickname(_ nickname: String) -> Bool {

        let nicknamePattern = Regex {
            Repeat(1...30) {
                CharacterClass(
                    .anyOf("._%+-"),
                    ("A"..."Z"),
                    ("0"..."9"),
                    ("a"..."z"),
                    ("ㄱ"..."ㅎ"),
                    ("ㅏ"..."ㅣ"),
                    ("가"..."힣")
                )
            }
        }

        return nickname.wholeMatch(of: nicknamePattern) != nil

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
        return phone.wholeMatch(of: phonePattern) != nil

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
            case .emailInvalid:
                String(localized: "이메일 형식이 올바르지 않습니다.")
            case .emailValid:
                String(localized: "사용 가능한 이메일입니다.")
            case .emailDuplicated:
                String(localized: "이미 가입된 회원입니다. 로그인을 진행해주세요.")
            case .etc:
                String(localized: "에러가 발생했어요. 잠시 후 다시 시도해주세요.")
            }
        }
    }

}
