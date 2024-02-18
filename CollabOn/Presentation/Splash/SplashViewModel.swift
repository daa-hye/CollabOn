//
//  SplashViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/14/24.
//

import Foundation
import RxSwift
import RxRelay

final class SplashViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let isLoggedIn = PublishRelay<Bool>()

    struct Input {

    }

    struct Output {
        let isLoggedIn: Observable<Bool>
    }

    init() {

        input = .init()

        output = .init(
            isLoggedIn: isLoggedIn.observe(on: MainScheduler.instance)
        )

        UserManager.shared.userInfo
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, info in
                if info != nil {
                    owner.isLoggedIn.accept(true)
                } else {
                    owner.isLoggedIn.accept(false)
                }
            }
            .disposed(by: disposeBag)
    }

}
