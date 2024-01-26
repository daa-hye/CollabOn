//
//  HomeViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/15/24.
//

import Foundation
import RxSwift
import RxRelay

final class HomeViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let service = WorkspaceManager()

    private let viewDidLoad = PublishSubject<Void>()
    private let workspace = ReplayRelay<WorkspaceDetail?>.create(bufferSize: 1)


    struct Input {
        let viewDidLoad: AnyObserver<Void>
    }

    struct Output {
        let workspace: Observable<WorkspaceDetail?>
    }

    init() {

        input = .init(
            viewDidLoad: viewDidLoad.asObserver()
        )

        output = .init(workspace: workspace.asObservable())

        viewDidLoad
            .withUnretained(self)
            .flatMapLatest { `self`, _ -> Single<WorkspaceDetail?> in
                self.service.getCurrentWorkspace()
            }
            .subscribe(with: self) { owner, detail in
                owner.workspace.accept(detail)
            }
            .disposed(by: disposeBag)

    }
}
