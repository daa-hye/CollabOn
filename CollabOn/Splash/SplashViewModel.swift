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

    struct Input {

    }

    struct Output {

    }

    init() {
        input = .init()
        output = .init()
    }

}
