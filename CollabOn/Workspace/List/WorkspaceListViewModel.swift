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
    private let workspaceOwnerId = PublishSubject<Int>()
    private let workspaces = PublishSubject<[WorkspaceResponse]>()
    private let isOwner = PublishSubject<Bool>()

    struct Input {
        let isExpanded: AnyObserver<Bool>
        let workspaceOwnerId: AnyObserver<Int>
    }

    struct Output {
        let workspaces: Observable<[WorkspaceResponse]>
        let isOwner: Observable<Bool>
    }

    init() {
        input = .init(
            isExpanded: isExpanded.asObserver(), 
            workspaceOwnerId: workspaceOwnerId.asObserver()
        )
        output = .init(
            workspaces: workspaces.observe(on: MainScheduler.instance), 
            isOwner: isOwner.observe(on: MainScheduler.instance)
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

        workspaceOwnerId
            .map { $0 == AppUserData.userId }
            .bind(to: isOwner)
            .disposed(by: disposeBag)
    }

}
