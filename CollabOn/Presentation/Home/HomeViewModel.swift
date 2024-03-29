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

    private let isExpanded = PublishSubject<Bool>()
    private let selectedWorkspace = PublishSubject<WorkspaceResponse>()
    private let leaveButtonDidTap = PublishSubject<Void>()
    private let changeAdminButtonDidTap = PublishSubject<Void>()
    private let deleteButtonDidTap = PublishSubject<Void>()

    private let workspaces = BehaviorRelay<[WorkspaceResponse]>(value: [])
    private let currentWorkspace = ReplayRelay<WorkspaceDetail?>.create(bufferSize: 1)
    private let selectedIndexPath = ReplayRelay<IndexPath>.create(bufferSize: 1)
    private let profile = ReplayRelay<URL>.create(bufferSize: 1)
    private let sections = BehaviorRelay<[HomeViewSection]>.init(value: [])
    private let isAdmin = BehaviorRelay<Bool>(value: false)

    struct Input {
        let isExpanded: AnyObserver<Bool>
        let selectedWorkspace: AnyObserver<WorkspaceResponse>
        let leaveButtonDidTap: AnyObserver<Void>
        let deleteButtonDidTap: AnyObserver<Void>
    }

    struct Output {
        let workspaces: Observable<[WorkspaceResponse]>
        let sections: Observable<[HomeViewSection]>
        let isAdmin: Observable<Bool>
        let profile: Observable<URL>
        let currentWorkspace: Observable<WorkspaceDetail?>
        let selectedIndexPath: Observable<IndexPath>
    }

    init() {

        input = .init(
            isExpanded: isExpanded.asObserver(),
            selectedWorkspace: selectedWorkspace.asObserver(),
            leaveButtonDidTap: leaveButtonDidTap.asObserver(), 
            deleteButtonDidTap: deleteButtonDidTap.asObserver()
        )

        output = .init(
            workspaces: workspaces.observe(on: MainScheduler.instance),
            sections: sections.observe(on: MainScheduler.instance),
            isAdmin: isAdmin.observe(on: MainScheduler.instance), 
            profile: profile.observe(on: MainScheduler.instance),
            currentWorkspace: currentWorkspace.observe(on: MainScheduler.instance),
            selectedIndexPath: selectedIndexPath.observe(on: MainScheduler.instance)
        )

        WorkspaceManager.shared.fetchCurrentWorkspace()

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
                WorkspaceService.shared.getWorkspaces()
                    .catchAndReturn([])
            }
            .subscribe(with: self) { owner, response in
                owner.workspaces.accept(response)
            }
            .disposed(by: disposeBag)

        UserManager.shared.userInfo
            .compactMap { $0?.profileImage }
            .bind(to: profile)
            .disposed(by: disposeBag)

        WorkspaceManager.shared.currentWorkspace
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

        deleteButtonDidTap
            .withLatestFrom(currentWorkspace)
            .compactMap { $0 }
            .subscribe(with: self) { owner, workspace in
                _ = WorkspaceService.shared.deleteWorkspace(workspace.workspaceId)
                    .catchAndReturn(())
                WorkspaceManager.shared.fetchCurrentWorkspace()
            }
            .disposed(by: disposeBag)

        currentWorkspace
            .compactMap { $0?.workspaceId }
            .flatMapLatest { id in
                ChannelService.shared.getMyChannels(id: id)
            }
            .map { channels in
                var items: [HomeViewSectionItem] = []
                for channel in channels {
                    var num = 0
                    let lastConnect = WorkspaceManager.shared.getLastConnect(channel.channelId)
                    _ = ChannelService.shared.getNumberOfUnreadChannelChats(id: channel.workspaceId, name: channel.name, after: lastConnect)
                        .asObservable()
                        .observe(on: MainScheduler.instance)
                        .bind {
                            num = $0
                        }
                    items.append(HomeViewSectionItem.channelItem(data: channel, count: num))
                }
                return [HomeViewSection.channel(items: items),
                        HomeViewSection.dms(items: []),
                        HomeViewSection.add]
            }
            .bind(with: self) { owner, value in
                owner.sections.accept(value)
            }
            .disposed(by: disposeBag)

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
    case channelItem(data: ChannelResponse, count: Int)
    case dmsItem(data: DmsResponse, count: Int)
}

