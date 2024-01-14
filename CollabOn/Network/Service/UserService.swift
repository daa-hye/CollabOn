//
//  UserService.swift
//  CollabOn
//
//  Created by 박다혜 on 1/8/24.
//

import Foundation
import Alamofire
import RxSwift

class UserService: Service {

    static let shared = UserService()

    private override init() {}

}

extension UserService {

    func emailLogin(_ data: EmailLogin) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.emailLogin(model: data))
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        guard let statusCode = response.response?.statusCode else { return }
                        let result = self.handleResponse(statusCode: statusCode, data, type: EmailLoginResponse.self)
                        switch result {
                        case .success(let value):
                            guard let value = value else {  return observer(.failure(EndPointError.undefinedError)) }
                            AppUserData.nickname = value.nickname
                            AppUserData.token = value.accessToken
                            AppUserData.token = value.refreshToken
                            observer(.success(()))
                        case .failure(let error):
                            observer(.failure(error))
                        }
                    case .failure:
                        observer(.failure(EndPointError.networkError))
                    }
                }

            return Disposables.create {
                request.cancel()
            }

        }
    }

    func appleJoin(_ data: AppleJoin) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.appleJoin(model: data))
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        guard let statusCode = response.response?.statusCode else { return }
                        let result = self.handleResponse(statusCode: statusCode, data, type: LoginResponse.self)
                        switch result {
                        case .success(let value):
                            guard let value = value else {  return observer(.failure(EndPointError.undefinedError)) }
                            AppUserData.nickname = value.nickname
                            AppUserData.profileImage = value.profileImage ?? ""
                            AppUserData.token = value.token.accessToken
                            AppUserData.token = value.token.refreshToken
                            observer(.success(()))
                        case .failure(let error):
                            observer(.failure(error))
                        }
                    case .failure:
                        observer(.failure(EndPointError.networkError))
                    }
                }

            return Disposables.create {
                request.cancel()
            }

        }
    }

    func appleLogin(_ data: AppleLogin) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.appleLogin(model: data))
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        guard let statusCode = response.response?.statusCode else { return }
                        let result = self.handleResponse(statusCode: statusCode, data, type: LoginResponse.self)
                        switch result {
                        case .success(let value):
                            guard let value = value else {  return observer(.failure(EndPointError.undefinedError)) }
                            AppUserData.nickname = value.nickname
                            AppUserData.profileImage = value.profileImage ?? ""
                            AppUserData.token = value.token.accessToken
                            AppUserData.token = value.token.refreshToken
                            observer(.success(()))
                        case .failure(let error):
                            observer(.failure(error))
                        }
                    case .failure:
                        observer(.failure(EndPointError.networkError))
                    }
                }

            return Disposables.create {
                request.cancel()
            }

        }
    }

    func kakaoLogin(_ data: KakaoLogin) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.kakakLogin(model: data))
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        guard let statusCode = response.response?.statusCode else { return }
                        let result = self.handleResponse(statusCode: statusCode, data, type: LoginResponse.self)
                        switch result {
                        case .success(let value):
                            guard let value = value else {  return observer(.failure(EndPointError.undefinedError)) }
                            AppUserData.nickname = value.nickname
                            AppUserData.profileImage = value.profileImage ?? ""
                            AppUserData.token = value.token.accessToken
                            AppUserData.token = value.token.refreshToken
                            observer(.success(()))
                        case .failure(let error):
                            observer(.failure(error))
                        }
                    case .failure:
                        observer(.failure(EndPointError.networkError))
                    }
                }

            return Disposables.create {
                request.cancel()
            }

        }
    }

    func join(_ data: Join) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.join(model: data))
                .responseData { response in
                switch response.result {
                case .success(let data):
                    guard let statusCode = response.response?.statusCode else { return }
                    let result = self.handleResponse(statusCode: statusCode, data, type: LoginResponse.self)
                    switch result {
                    case .success(let value):
                        guard let value = value else {  return observer(.failure(EndPointError.undefinedError)) }
                        AppUserData.nickname = value.nickname
                        AppUserData.profileImage = value.profileImage ?? ""
                        AppUserData.token = value.token.accessToken
                        AppUserData.token = value.token.refreshToken
                        observer(.success(()))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                case .failure(_):
                    observer(.failure(EndPointError.networkError))
                }
            }

            return Disposables.create {
                request.cancel()
            }

        }
    }

    func validateEmail(_ data: Email) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.validationEmail(model: data))
                .response { response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    let result = self.handleResponse(statusCode: statusCode, response.data)
                    switch result {
                    case .success:
                        observer(.success(()))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                case .failure:
                    observer(.failure(EndPointError.networkError))
                }
            }

            return Disposables.create {
                request.cancel()
            }
            
        }
    }

}
