//
//  HomeViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/15/24.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

final class HomeViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let viewDidLoad = PublishSubject<Void>()
    private let isExpanded = PublishSubject<Bool>()
    private let selectedWorkspace = PublishSubject<WorkspaceResponse>()
    private let editButtonDidTap = PublishSubject<Void>()
    private let leaveButtonDidTap = PublishSubject<Void>()
    private let changeAdminButtonDidTap = PublishSubject<Void>()
    private let deleteButtonDidTap = PublishSubject<Void>()

    private let workspaces = BehaviorRelay<[WorkspaceResponse]>(value: [])
    private let currentWorkspace = ReplayRelay<WorkspaceDetail?>.create(bufferSize: 1)
    private let selectedIndexPath = ReplayRelay<IndexPath>.create(bufferSize: 1)
    private let sections = BehaviorRelay<[HomeViewSection]>.init(value: [])
    private let isAdmin = BehaviorRelay<Bool>(value: false)

    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let isExpanded: AnyObserver<Bool>
        let selectedWorkspace: AnyObserver<WorkspaceResponse>
        let leaveButtonDidTap: AnyObserver<Void>
    }

    struct Output {
        let workspaces: Observable<[WorkspaceResponse]>
        let sections: Observable<[HomeViewSection]>
        let isAdmin: Observable<Bool>
        let currentWorkspace: Observable<WorkspaceDetail?>
        let selectedIndexPath: Observable<IndexPath>
    }

    init() {

        input = .init(
            viewDidLoad: viewDidLoad.asObserver(),
            isExpanded: isExpanded.asObserver(),
            selectedWorkspace: selectedWorkspace.asObserver(), 
            leaveButtonDidTap: leaveButtonDidTap.asObserver()
        )

        output = .init(
            workspaces: workspaces.observe(on: MainScheduler.instance),
            sections: sections.asObservable(),
            isAdmin: isAdmin.observe(on: MainScheduler.instance),
            currentWorkspace: currentWorkspace.observe(on: MainScheduler.instance),
            selectedIndexPath: selectedIndexPath.observe(on: MainScheduler.instance)
        )

        viewDidLoad
            .subscribe { _ in
                WorkspaceManager.shared.fetchCurrentWorkspace()
            }
            .disposed(by: disposeBag)

        selectedWorkspace
            .subscribe(with: self) { owner, workspace in
                WorkspaceManager.shared.fetchCurrentWorkspace(id: workspace.workspaceId)
            }
            .disposed(by: disposeBag)

        currentWorkspace
            .map { $0?.ownerId == AppUserData.userId }
            .bind(to: isAdmin)
            .disposed(by: disposeBag)

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
            .compactMap { ($0.0, $0.1) }
            .map { ($0.0, $0.1?.workspaceId) }
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

        leaveButtonDidTap
            .withLatestFrom(currentWorkspace)
            .compactMap { $0 }
            .flatMapLatest { workspace -> Single<WorkspaceResponse?> in
                return WorkspaceService.shared.leaveWorkspace(workspace.workspaceId)
                    .catchAndReturn(nil)
            }
            .subscribe(with: self) { owner, workspace in
                WorkspaceManager.shared.fetchCurrentWorkspace(id: workspace?.workspaceId ?? nil)
            }
            .disposed(by: disposeBag)

//        viewDidLoad
//            .flatMap { _ in
//                Single.zip(api1, api2)
//            }
//            .map {
//                [HomeViewSection.channel(title: "header", items: $0.0),
//                 HomeViewSection.dms(title: "header", items: $0.1)
//                 ]
//            }
//
//        [
//            HomeViewSection.channel(title: "channel", items: [.channelItem(data: data)])
//            HomeViewSection.channel(title: "channel", items: [.dmsItem(data: )])
//            HomeViewSection.channel(title: "channel", items: [.addItem(title: <#T##String#>)])
//        ]

    }
}

enum HomeViewSection {
    case channel(items: [HomeViewSectionItem])
    case dms(items: [HomeViewSectionItem])
    case add
}

extension HomeViewSection: SectionModelType {
    
    typealias Item = HomeViewSectionItem

    var items: [HomeViewSectionItem] {
        switch self {
        case .channel(let items):
            return items
        case .dms(let items):
            return items
        case .add:
            return []
        }
    }
    
    init(original: HomeViewSection, items: [HomeViewSectionItem]) {
        switch original {
        case .channel(let items):
            self = .channel(items: items)
        case .dms(let items):
            self = .dms(items: items)
        case .add:
            self = .add
        }
    }

}

extension HomeViewSection {
    var header: String? {
        switch self {
        case .channel:
            return String(localized: "채널")
        case .dms:
            return String(localized: "다이렉트 메시지")
        case .add:
            return nil
        }
    }

    var footer: String {
        switch self {
        case .channel:
            return String(localized: "채널 추가")
        case .dms:
            return String(localized: "새 메시지 추가")
        case .add:
            return String(localized: "팀원 추가")
        }
    }
}

enum HomeViewSectionItem {
    case channelItem(data: Channel)
    case dmsItem(data: DmsResponse)
}

