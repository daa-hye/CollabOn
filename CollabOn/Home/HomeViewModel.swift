//
//  HomeViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/15/24.
//

import Foundation
import RxSwift

final class HomeViewModel: ViewModelType {

    let input: Input
    let output: Output

    let disposeBag = DisposeBag()

    struct Input {

    }

    struct Output {

    }

    init() {
        input = .init()
        output = .init()
    }

}
