//
//  WorkspaceAddViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/17/24.
//

import Foundation
import RxSwift
import RxRelay

final class WorkspaceAddViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let name = PublishSubject<String>()
    private let description = PublishSubject<String>()
    private let image = PublishSubject<Data>()
    private let confirmButtonDidTap = PublishSubject<Void>()
    private let isSuccess = PublishRelay<Bool>()

    struct Input {
        let name: AnyObserver<String>
        let description: AnyObserver<String>
        let image: AnyObserver<Data>
        let confirmButtonDidTap: AnyObserver<Void>
    }

    struct Output {
        let isSuccess: Observable<Bool>
    }

    init() {

        input = .init(
            name: name.asObserver(),
            description: description.asObserver(),
            image: image.asObserver(),
            confirmButtonDidTap: confirmButtonDidTap.asObserver())

        output = .init(
            isSuccess: isSuccess.observe(on: MainScheduler.instance)
        )

        confirmButtonDidTap
            .withLatestFrom(Observable.combineLatest(name, description, image))
            .flatMapLatest { (name, description, image) in
                WorkspaceService.shared.createWorkspace(Workspace(name: name, description: description, image: image))
                    .asObservable()
                    .materialize()
            }
            .subscribe(with: self) { owner, event in
                switch event {
                case .next(let data):
                    owner.isSuccess.accept(true)
                    WorkspaceManager.shared.fetchCurrentWorkspace(id: data.workspaceId)
                case .error(let error):
                    owner.isSuccess.accept(false)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

    }

}
