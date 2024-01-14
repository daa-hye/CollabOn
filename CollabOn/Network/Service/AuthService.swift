//
//  AuthService.swift
//  CollabOn
//
//  Created by 박다혜 on 1/8/24.
//

import Foundation
import Alamofire
import RxSwift

class AuthService: Service {

    static let shared = AuthService()

    private override init() {}

}

extension AuthService {

    func emailLogin(_ data: EmailLogin) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(AuthRouter.emailLogin(model: data))
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
            let request = self.AFManager.request(AuthRouter.appleJoin(model: data))
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
            let request = self.AFManager.request(AuthRouter.appleLogin(model: data))
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
                    case .failure(let failure):
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
            let request = self.AFManager.request(AuthRouter.kakakLogin(model: data))
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
            let request = self.AFManager.request(AuthRouter.join(model: data))
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
            let request = self.AFManager.request(AuthRouter.validationEmail(model: data))
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
                case .failure(let error):
                    observer(.failure(EndPointError.networkError))
                }
            }

            return Disposables.create {
                request.cancel()
            }
            
        }
    }

}
