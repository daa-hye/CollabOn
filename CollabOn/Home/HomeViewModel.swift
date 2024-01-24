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

//        viewDidLoad
//            .flatMapLatest { _ in
//                WorkspaceService.shared.getWorkspace()
//                    .catchAndReturn([])
//            }
//            .map { $0.first ?? nil }
//            .flatMapLatest { value -> Single<WorkspaceDetail> in
//                guard let value = value else { return Single.just(WorkspaceDetail()) }
//
//                if AppUserData.currentWorkspace != 0 {
//                    return WorkspaceService.shared.getWorkspace(AppUserData.currentWorkspace)
//                        .catchAndReturn(Single.just(WorkspaceDetail()))
//                }
//                else {
//                    return WorkspaceService.shared.getWorkspace(value.workspaceId)
//                        .catchAndReturn(Single.just(WorkspaceDetail()))
//                }
//            }
//            .subscribe(with: self) { owner, value in
//                if value.workspaceId == 0 {
//                    owner.workspace.onNext(nil)
//                } else {
//                    owner.workspace.onNext(value)
//                }
//            }
//            .disposed(by: disposeBag)
    }

}
