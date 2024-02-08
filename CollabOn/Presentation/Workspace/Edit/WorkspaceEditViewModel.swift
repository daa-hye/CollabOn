//
//  WorkspaceEditViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 2/2/24.
//

import Foundation
import RxSwift
import RxRelay

final class WorkspaceEditViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let workspace: WorkspaceDetail

    private let name = PublishSubject<String>()
    private let description = PublishSubject<String>()
    private let image = PublishSubject<Data>()
    private let saveButtonDidTap = PublishSubject<Void>()
    private let isSuccess = PublishRelay<Bool>()
    private let toastMessage = PublishRelay<String>()

    struct Input {
        let name: AnyObserver<String>
        let description: AnyObserver<String>
        let image: AnyObserver<Data>
        let saveButtonDidTap: AnyObserver<Void>
    }

    struct Output {
        let name: Observable<String>
        let description: Observable<String>
        let image: Observable<URL>
        let isSuccess: Observable<Bool>
        let toastMessage: Observable<String>
    }

    init(workspace: WorkspaceDetail) {

        self.workspace = workspace

        input = .init(
            name: name.asObserver(),
            description: description.asObserver(),
            image: image.asObserver(),
            saveButtonDidTap: saveButtonDidTap.asObserver())

        output = .init(
            name: BehaviorSubject(value: workspace.name),
            description: BehaviorSubject(value: workspace.description),
            image: BehaviorSubject(value: workspace.thumbnail!), 
            isSuccess: isSuccess.observe(on: MainScheduler.instance), 
            toastMessage: toastMessage.observe(on: MainScheduler.instance)
        )

        saveButtonDidTap
            .withLatestFrom(Observable.combineLatest(name, description, image))
            .flatMapLatest { (name, description, image) in
                WorkspaceService.shared.editWorkspace(workspace.workspaceId, Workspace(name: name, description: description, image: image))
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
                    switch error {
                    case EndPointError.duplicateData:
                        owner.toastMessage.accept(Toast.workspaceNameDuplicated.message)
                    default:
                        owner.toastMessage.accept(Toast.etc.message)
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

    }

}

extension WorkspaceEditViewModel {

    private enum Toast: Int {
        case workspaceNameDuplicated
        case etc

        var message: String {
            switch self {
            case .workspaceNameDuplicated:
                String(localized: "이미 같은 이름의 워크스페이스가 있어요.")
            case .etc:
                String(localized: "에러가 발생했어요. 잠시 후 다시 시도해주세요.")
            }
        }
    }

}

