//
//  HomeViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/15/24.
//

import Foundation
import RxSwift

final class HomeViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let viewDidLoad = PublishSubject<Void>()
    private let workspace = BehaviorSubject<WorkspaceDetail?>(value: nil)

    struct Input {
        let viewDidLoad: AnyObserver<Void>
    }

    struct Output {

    }

    init() {

        input = .init(
            viewDidLoad: viewDidLoad.asObserver()
        )

        output = .init()

        viewDidLoad
            .flatMapLatest { _ in
                WorkspaceService.shared.getWorkspace()
                    .catchAndReturn([])
            }
            .map { $0.first ?? nil }
            .flatMapLatest { value in
                guard let value = value else {
                    return Single.just(WorkspaceDetail(workspaceId: 0, name: "", description: "", thumbnail: "", ownerId: 0, createdAt: "", channels: [], workspaceMembers: []))
                }

                if AppUserData.currentWorkspace != 0 {
                    return WorkspaceService.shared.getWorkspace(AppUserData.currentWorkspace)
                        .catchAndReturn(WorkspaceDetail(workspaceId: 0, name: "", description: "", thumbnail: "", ownerId: 0, createdAt: "", channels: [], workspaceMembers: []))
                }
                else {
                    return WorkspaceService.shared.getWorkspace(value.workspaceId)
                        .catchAndReturn(WorkspaceDetail(workspaceId: 0, name: "", description: "", thumbnail: "", ownerId: 0, createdAt: "", channels: [], workspaceMembers: []))
                }
            }
            .subscribe(with: self, onNext: { owner, value in
                if value.workspaceId == 0 {
                    owner.workspace.onNext(nil)
                } else {
                    owner.workspace.onNext(value)
                }
            })

            .disposed(by: disposeBag)
    }

}
