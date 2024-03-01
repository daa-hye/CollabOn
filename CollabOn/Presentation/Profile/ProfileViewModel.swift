//
//  ProfileViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 3/1/24.
//

import Foundation
import RxSwift
import RxRelay

final class ProfileViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    struct Input {

    }

    struct Output {
        let profile: Observable<URL>
    }

    init() {
        input = .init()
        output = .init(
            profile: UserManager.shared.userInfo.compactMap{ $0?.profileImage }
        )

    }

}
