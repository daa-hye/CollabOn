//
//  WorkspaceListViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/23/24.
//

import Foundation
import RxSwift

class WorkspaceListViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let isExpanded = PublishSubject<Bool>()

    struct Input {
        let isExpanded: AnyObserver<Bool>
    }

    struct Output {

    }

    init() {
        input = .init(
            isExpanded: isExpanded.asObserver()
        )
        output = .init(
        )

        isExpanded
            .filter { $0 }
            .flatMapLatest { _ in
                WorkspaceService.shared.getWorkspace()
                    .catchAndReturn([])
            }
            .subscribe(with: self) { onwer, response in

            }
            .disposed(by: disposeBag)
    }

}
