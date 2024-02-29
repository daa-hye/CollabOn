//
//  WorkspaceManager.swift
//  CollabOn
//
//  Created by 박다혜 on 1/26/24.
//

import Foundation
import RxSwift
import RxRelay

final class WorkspaceManager {

    static let shared = WorkspaceManager()

    private let repository = ChannelRepository()

    private init() {
        _ = currentWorkspace
            .compactMap { $0?.workspaceId }
            .subscribe { value in
                AppUserData.currentWorkspace = value
            }
    }

    var currentWorkspace = ReplayRelay<WorkspaceDetail?>.create(bufferSize: 1)

    func fetchCurrentWorkspace() {
        _ = WorkspaceService.shared.getWorkspaces()
            .map { response -> Int? in
                response.isEmpty ? nil : response.first!.workspaceId
            }
            .flatMap { id -> Single<WorkspaceDetail?> in
                if let id = id {
                    AppUserData.currentWorkspace = id
                }
                return self.getWorkspace(id)
            }
            .subscribe {
                self.currentWorkspace.accept($0)
            }
    }

    func fetchCurrentWorkspace(id: Int?) {
        guard let id = id else {
            AppUserData.currentWorkspace = 0
            return self.currentWorkspace.accept(nil)
        }
        AppUserData.currentWorkspace = id
        _ = WorkspaceService.shared.getWorkspace(id)
            .map { Optional($0) }
            .catch { _ in
                Single<WorkspaceDetail?>.just(nil)
            }
            .subscribe {
                self.currentWorkspace.accept($0)
            }
    }

    func getLastConnect(_ id: Int) -> String? {
        repository.getLastConnect(id)
    }

}

extension WorkspaceManager {
    private func getWorkspace(_ id: Int?) -> PrimitiveSequence<SingleTrait, WorkspaceDetail?> {
        guard let id else { return Single<WorkspaceDetail?>.just(nil) }

        let _getWorkspace = {
            WorkspaceService.shared.getWorkspace(id)
                .map { Optional($0) }
                .catch { _ in
                    Single<WorkspaceDetail?>.just(nil)
                }
        }

        let workspaceId = AppUserData.currentWorkspace
        if workspaceId != 0 {
            return WorkspaceService.shared.getWorkspace(workspaceId)
                .map { Optional($0) }
                .catch { _ in
                    return _getWorkspace()
                }
        } else {
            return _getWorkspace()
        }
    }
}
