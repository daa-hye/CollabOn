//
//  WorkspaceChangeAdminViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 2/5/24.
//

import Foundation
import RxSwift
import RxRelay

final class WorkspaceChangeAdminViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let viewDidLoad = PublishSubject<Void>()
    private let selectedMember = PublishSubject<Member>()
    private let members = ReplayRelay<[Member]>.create(bufferSize: 1)

    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let selectedMember: AnyObserver<Member>
    }

    struct Output {
        let members: Observable<[Member]>
    }

    init() {
        input = .init(
            viewDidLoad: viewDidLoad.asObserver(), 
            selectedMember: selectedMember.asObserver()
        )

        output = .init(
            members: members.observe(on: MainScheduler.instance)
        )

        viewDidLoad
            .withLatestFrom(WorkspaceManager.shared.currentWorkspace)
            .compactMap { $0 }
            .flatMapLatest {
                WorkspaceService.shared.getAllMembers($0.workspaceId)
                    .catchAndReturn([])
            }
            .bind(to: members)
            .disposed(by: disposeBag)

        selectedMember
            .withLatestFrom(WorkspaceManager.shared.currentWorkspace) { ($0, $1) }
            .compactMap { $0 }
            .flatMapLatest {
                WorkspaceService.shared.changeWorkspaceAdmin(id: $0.1!.workspaceId, userId: $0.0.userId)
                    .asObservable()
                    .materialize()
            }
            .subscribe(with: self) { owner, event in
                switch event {
                case .next(let value):
                    WorkspaceManager.shared.fetchCurrentWorkspace(id: value.workspaceId)
                case .error(let error):
                    print(error)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }

}
