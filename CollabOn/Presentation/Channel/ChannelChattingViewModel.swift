//
//  ChannelChattingViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 2/23/24.
//

import Foundation
import RxSwift
import RxRelay

class ChannelChattingViewModel: ViewModelType {

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
