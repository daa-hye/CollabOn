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
    private let toastMessage = PublishRelay<String>()

    struct Input {
        let name: AnyObserver<String>
        let description: AnyObserver<String>
        let image: AnyObserver<Data>
        let confirmButtonDidTap: AnyObserver<Void>
    }

    struct Output {
        let isSuccess: Observable<Bool>
        let toastMessage: Observable<String>
    }

    init() {

        input = .init(
            name: name.asObserver(),
            description: description.asObserver(),
            image: image.asObserver(),
            confirmButtonDidTap: confirmButtonDidTap.asObserver())

        output = .init(
            isSuccess: isSuccess.observe(on: MainScheduler.instance), 
            toastMessage: toastMessage.observe(on: MainScheduler.instance)
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
                    switch error {
                    case EndPointError.duplicateData:
                        owner.toastMessage.accept(Toast.workspaceNameDuplicated.message)
                    case EndPointError.insufficientCoins:
                        owner.toastMessage.accept(Toast.notEnoughCoins.message)
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

extension WorkspaceAddViewModel {

    private enum Toast: Int {
        case workspaceNameDuplicated
        case notEnoughCoins
        case etc

        var message: String {
            switch self {
            case .workspaceNameDuplicated:
                String(localized: "이미 같은 이름의 워크스페이스가 있어요.")
            case .notEnoughCoins:
                String(localized: "새싹 코인이 부족해요.")
            case .etc:
                String(localized: "에러가 발생했어요. 잠시 후 다시 시도해주세요.")
            }
        }
    }

}

