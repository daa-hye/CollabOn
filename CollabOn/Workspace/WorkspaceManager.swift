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
                return self.getWorkspace(id)
            }
            .subscribe {
                self.currentWorkspace.accept($0)
            }
    }

    func fetchCurrentWorkspace(id: Int?) {
        guard let id = id else { return self.currentWorkspace.accept(nil) }
        _ = WorkspaceService.shared.getWorkspace(id)
            .map { Optional($0) }
            .catch { _ in
                Single<WorkspaceDetail?>.just(nil)
            }
            .subscribe {
                self.currentWorkspace.accept($0)
            }
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
