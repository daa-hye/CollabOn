//
//  WorkspaceListViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/23/24.
//

import Foundation
import RxSwift
import RxDataSources

class WorkspaceListViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let isExpanded = PublishSubject<Bool>()
    private let workspaces = PublishSubject<[WorkspaceResponse]>()

    struct Input {
        let isExpanded: AnyObserver<Bool>
    }

    struct Output {
        let workspaces: Observable<[WorkspaceResponse]>
    }

    init() {
        input = .init(
            isExpanded: isExpanded.asObserver()
        )
        output = .init(
            workspaces: workspaces.observe(on: MainScheduler.instance)
        )

        isExpanded
            .filter { $0 }
            .flatMapLatest { _ in
                WorkspaceService.shared.getWorkspace()
                    .catchAndReturn([])
            }
            .subscribe(with: self) { owner, response in
                owner.workspaces.onNext(response)
            }
            .disposed(by: disposeBag)
    }

}
