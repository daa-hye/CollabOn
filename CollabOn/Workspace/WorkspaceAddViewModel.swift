//
//  WorkspaceAddViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/17/24.
//

import Foundation
import RxSwift

class WorkspaceAddViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let name = PublishSubject<String>()
    private let description = PublishSubject<String>()
    private let image = PublishSubject<Data>()
    private let confirmButtonDidTap = PublishSubject<Void>()

    struct Input {
        let name: AnyObserver<String>
        let description: AnyObserver<String>
        let image: AnyObserver<Data>
        let confirmButtonDidTap: AnyObserver<Void>
    }

    struct Output {
        
    }

    init() {

        input = .init(
            name: name.asObserver(),
            description: description.asObserver(),
            image: image.asObserver(),
            confirmButtonDidTap: confirmButtonDidTap.asObserver())

        output = .init()

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
                    print(data)
                case .error(let error):
                    print(error)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

    }

}
