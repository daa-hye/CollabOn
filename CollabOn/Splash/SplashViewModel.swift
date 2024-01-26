//
//  SplashViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/14/24.
//

import Foundation
import RxSwift

final class SplashViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let viewDidLoad = PublishSubject<Void>()

    private let isLoggedIn = PublishSubject<Bool>()

    struct Input {
        let viewDidLoad: AnyObserver<Void>
    }

    struct Output {
        let isLoggedIn: Observable<Bool>
    }

    init() {

        input = .init(
            viewDidLoad: viewDidLoad.asObserver()
        )

        output = .init(
            isLoggedIn: isLoggedIn.observe(on: MainScheduler.instance)
        )

        viewDidLoad
            .delay(.seconds(0), scheduler: MainScheduler.instance)
            .flatMapLatest { _ -> Observable<Event<Bool>> in
                if AppUserData.token.isEmpty {
                    self.isLoggedIn.onNext(false)
                    return Observable.never()
                } else {
                    return UserService.shared.getUserLoginData()
                        .asObservable()
                        .materialize()
                }
            }
            .subscribe(with: self) { owner, event in
                switch event {
                case .next(let value):
                    owner.isLoggedIn.onNext(value)
                case .error:
                    owner.isLoggedIn.onNext(false)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }

}
