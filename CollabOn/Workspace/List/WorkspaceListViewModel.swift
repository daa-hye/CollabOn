//
//  WorkspaceListViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/23/24.
//

import Foundation
import RxSwift
import RxRelay

class WorkspaceListViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let isExpanded = PublishSubject<Bool>()
    private let workspaces = BehaviorRelay<[WorkspaceResponse]>.init(value: [])
    private let currentWorkspace = ReplayRelay<WorkspaceDetail>.create(bufferSize: 1)
    private let selectedIndexPath = ReplayRelay<IndexPath>.create(bufferSize: 1)

    struct Input {
        let isExpanded: AnyObserver<Bool>
    }

    struct Output {
        let workspaces: Observable<[WorkspaceResponse]>
        let currentWorkspace: Observable<WorkspaceDetail>
        let selectedIndexPath: Observable<IndexPath>
    }

    init() {

        input = .init(
            isExpanded: isExpanded.asObserver()
        )
        output = .init(
            workspaces: workspaces.observe(on: MainScheduler.instance), 
            currentWorkspace: currentWorkspace.observe(on: MainScheduler.instance),
            selectedIndexPath: selectedIndexPath.observe(on: MainScheduler.instance)
        )

        isExpanded
            .filter { $0 }
            .flatMapLatest { _ in
                WorkspaceService.shared.getWorkspace()
                    .catchAndReturn([])
            }
            .subscribe(with: self) { owner, response in
                owner.workspaces.accept(response)
            }
            .disposed(by: disposeBag)

        WorkspaceManager.shared.currentWorkspace
            .compactMap { $0 }
            .bind(to: currentWorkspace)
            .disposed(by: disposeBag)

        Observable.combineLatest(workspaces, currentWorkspace)
            .map { ($0.0, $0.1.workspaceId) }
            .flatMap { (list, currentWorkspace) -> Observable<IndexPath> in
                for (index, item) in list.enumerated() {
                    if item.workspaceId == currentWorkspace {
                        return Observable.just(IndexPath(row: index, section: 0))
                    }
                }
                return Observable.empty()
            }
            .bind(to: selectedIndexPath)
            .disposed(by: disposeBag)

    }

}
