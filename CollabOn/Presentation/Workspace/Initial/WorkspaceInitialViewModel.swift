//
//  WorkspaceInitialViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 2/18/24.
//

import Foundation
import RxSwift
import RxRelay

final class WorkspaceInitialViewModel: ViewModelType {

    let input: Input
    let output: Output

    let disposeBag = DisposeBag()

    private let nickname = ReplayRelay<String>.create(bufferSize: 1)

    struct Input {
        
    }

    struct Output {
        let nickname: Observable<String>
    }

    init() {
        input = .init()
        
        output = .init(
            nickname: nickname.observe(on: MainScheduler.instance)
        )

        UserManager.shared.userInfo
            .compactMap {$0?.nickname}
            .bind(to: nickname)
            .disposed(by: disposeBag)
    }

}
