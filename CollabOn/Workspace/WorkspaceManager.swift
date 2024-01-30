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

    private init() {}

    var currentWorkspace = ReplayRelay<WorkspaceDetail?>.create(bufferSize: 1)

    // 업데이트, 추가, 수정, 삭제
    // 갱신 정보 전달

    func fetchCurrentWorkspace() {
        // TODO: `WorkspaceService.shared.getWorkspace()` 함수 workspaces로 네이밍 변경하기
        _ = WorkspaceService.shared.getWorkspace()
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

        if let workspaceId = AppUserData.currentWorkspace {
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
