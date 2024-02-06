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

    func getWorkspace() -> Single<[WorkspaceResponse]> {
        Single.create { observer in
            let request = self.AFManager.request(WorkspaceRouter.getAllWorkspaces)
                .validate(statusCode: 200...300)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let result = self.handleResponse(data, type: [WorkspaceResponse].self) {
                            observer(.success(result))
                        } else {
                            observer(.failure(EndPointError.undefinedError))
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
                .responseDecodable(of: WorkspaceDetail.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(value))
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

    func editWorkspace(_ id: Int, _ data: Workspace) -> Single<WorkspaceResponse> {
        Single.create { observer in
            let request = self.AFManager.upload(multipartFormData: WorkspaceRouter.editWorkspace(id: id, model: data).multipart, with: WorkspaceRouter.editWorkspace(id: id, model: data))
                .validate(statusCode: 200...300)
                .responseDecodable(of: WorkspaceResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer(.success(data))
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

    func deleteWorkspace(_ id: Int) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(WorkspaceRouter.deleteWorkspace(id: id))
                .validate(statusCode: 200...300)
                .response { response in
                    switch response.result {
                    case .success:
                        observer(.success(()))
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

    func addWorkspaceMember(_ id: Int, _ data: Email) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(WorkspaceRouter.addWorkspaceMember(id: id, model: data))
                .validate(statusCode: 200...300)
                .response { response in
                    switch response.result {
                    case .success:
                        observer(.success(()))
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

    func getAllMembers(_ id: Int) -> Single<[Member]> {
        Single.create { observer in
            let request = self.AFManager.request(WorkspaceRouter.getAllMembers(id: id))
                .validate(statusCode: 200...300)
                .responseDecodable(of: [Member].self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(value))
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

    func leaveWorkspace(_ id: Int) -> Single<WorkspaceResponse?> {
        Single.create { observer in
            let request = self.AFManager.request(WorkspaceRouter.leaveWorkspace(id: id))
                .validate(statusCode: 200...300)
                .responseDecodable(of: [WorkspaceResponse].self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(value.first ?? nil))
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

    func changeWorkspaceAdmin(id: Int, userId: Int) -> Single<WorkspaceResponse> {
        Single.create { observer in
            let request = self.AFManager.request(WorkspaceRouter.changeWorkspaceAdmin(id: id, userId: userId))
                .validate(statusCode: 200...300)
                .responseDecodable(of: WorkspaceResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(value))
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
