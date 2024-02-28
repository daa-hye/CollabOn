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

}
