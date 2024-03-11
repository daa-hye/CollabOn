//
//  ChannelService.swift
//  CollabOn
//
//  Created by 박다혜 on 2/19/24.
//

import Foundation
import Alamofire
import RxSwift

final class ChannelService: Service {
    static let shared = ChannelService()
    private override init() {}
}

extension ChannelService {

    func createChannel(id: Int, data: Channel) -> Single<ChannelResponse> {
        Single.create { observer in
            let request = self.AFManager.request(ChannelRouter.createChannel(id: id, model: data))
                .validate(statusCode: 200...300)
                .responseDecodable(of: ChannelResponse.self) { response in
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

    func getAllChannels(id: Int) -> Single<[ChannelResponse]> {
        Single.create { observer in
            let request = self.AFManager.request(ChannelRouter.getAllChannels(id: id))
                .validate(statusCode: 200...300)
                .responseDecodable(of: [ChannelResponse].self) { response in
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

    func getMyChannels(id: Int) -> Single<[ChannelResponse]> {
        Single.create { observer in
            let request = self.AFManager.request(ChannelRouter.getMyChannels(id: id))
                .validate(statusCode: 200...300)
                .responseDecodable(of: [ChannelResponse].self) { response in
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

    func getChannelByName(id: Int, name: String) -> Single<ChannelResponse> {
        Single.create { observer in
            let request = self.AFManager.request(ChannelRouter.getChannelByName(id: id, name: name))
                .validate(statusCode: 200...300)
                .responseDecodable(of: ChannelResponse.self) { response in
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

    func editChannel(id: Int, name: String, data: Channel) -> Single<ChannelResponse> {
        Single.create { observer in
            let request = self.AFManager.request(ChannelRouter.editChannel(id: id, name: name, model: data))
                .validate(statusCode: 200...300)
                .responseDecodable(of: ChannelResponse.self) { response in
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

    func deleteChannel(id: Int, name: String) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(ChannelRouter.deleteChannel(id: id, name: name))
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

    func sendChannelChat(id: Int, name: String, model: Chats) -> Single<ChatResponse> {
        Single.create { observer in
            let request = self.AFManager.upload(multipartFormData: ChannelRouter.sendChannelChat(id: id, name: name, model: model).multipart, with: ChannelRouter.sendChannelChat(id: id, name: name, model: model))
                .validate(statusCode: 200...300)
                .responseDecodable(of: ChatResponse.self) { response in
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

    func getChannelChats(id: Int, name: String, cursor: String) -> Single<[ChatResponse]> {
        Single.create { observer in
            let request = self.AFManager.request(ChannelRouter.getChannelChats(id: id, name: name, cursor: cursor))
                .validate(statusCode: 200...300)
                .responseDecodable(of: [ChatResponse].self) { response in
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

    func getNumberOfUnreadChannelChats(id: Int, name: String, after: String?) -> Single<Int> {
        Single.create { observer in
            let request = self.AFManager.request(ChannelRouter.getNumberOfUnreadChannelChats(id: id, name: name, after: after))
                .validate(statusCode: 200...300)
                .responseDecodable(of: UnreadResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(value.count))
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

    func getChannelMembers(id: Int, name: String) -> Single<[Member]> {
        Single.create { observer in
            let request = self.AFManager.request(ChannelRouter.getChannelMembers(id: id, name: name))
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

    func leaveChannel(id: Int, name: String) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(ChannelRouter.leaveChannel(id: id, name: name))
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

    func changeChannelAdmin(id: Int, name: String, userId: Int) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(ChannelRouter.changeChannelAdmin(id: id, name: name, userId: userId))
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

}
