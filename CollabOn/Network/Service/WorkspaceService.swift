//
//  WorkspaceService.swift
//  CollabOn
//
//  Created by 박다혜 on 1/15/24.
//

import Foundation
import Alamofire
import RxSwift

final class WorkspaceService: Service {
    static let shared = WorkspaceService()
    private override init() {}
}

extension WorkspaceService {

    func createWorkspace(_ data: Workspace) -> Single<WorkspaceResponse> {
        Single.create { observer in
            let request = self.AFManager.upload(multipartFormData: WorkspaceRouter.createWorkspace(model: data).multipart, with: WorkspaceRouter.createWorkspace(model: data))
                .validate(statusCode: 200...300)
                .responseDecodable(of: WorkspaceResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer(.success(data))
                    case .failure(let failure):
                        guard let statusCode = response.response?.statusCode, let data = response.data else {
                            return observer(.failure(EndPointError.networkError))
                        }
                        let error = self.handleError(statusCode: statusCode, data)
                        observer(.failure(error))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func getWorkspace() -> Single<[WorkspaceResponse]> {
        Single.create { observer in
            let request = self.AFManager.request(WorkspaceRouter.getAllWorkspaces)
                .validate(statusCode: 200...300)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let result = self.handleResponse(data, type: [WorkspaceResponse].self) {
                            observer(.success(result))
                        }
                    case .failure:
                        guard let statusCode = response.response?.statusCode, let data = response.data else {
                            return observer(.failure(EndPointError.networkError))
                        }
                        let error = self.handleError(statusCode: statusCode, data)
                        observer(.failure(error))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func getWorkspace(_ id: Int) -> Single<WorkspaceDetail> {
        Single.create { observer in
            let request = self.AFManager.request(WorkspaceRouter.getWorkspaceById(id: id))
                .validate(statusCode: 200...300)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let result = self.handleResponse(data, type: WorkspaceDetail.self) {
                            observer(.success(result))
                        }
                    case .failure:
                        guard let statusCode = response.response?.statusCode, let data = response.data else {
                            return observer(.failure(EndPointError.networkError))
                        }
                        let error = self.handleError(statusCode: statusCode, data)
                        observer(.failure(error))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }

}
