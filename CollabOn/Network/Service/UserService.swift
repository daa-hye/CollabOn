//
//  UserService.swift
//  CollabOn
//
//  Created by 박다혜 on 1/8/24.
//

import Foundation
import Alamofire
import RxSwift

final class UserService: Service {
    static let shared = UserService()
    private override init() {}
}

extension UserService {

    func join(_ data: Join) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.join(model: data))
                .responseData { response in
                switch response.result {
                case .success(let data):
                    if let result = self.handleResponse(data, type: LoginResponse.self) {
                        AppUserData.nickname = result.nickname
                        AppUserData.profileImage = result.profileImage ?? ""
                        AppUserData.token = result.token.accessToken
                        AppUserData.refreshToken = result.token.refreshToken
                        observer(.success(()))
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

    func validateEmail(_ data: Email) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.validationEmail(model: data))
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

    func emailLogin(_ data: EmailLogin) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.emailLogin(model: data))
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let result = self.handleResponse(data, type: EmailLoginResponse.self) {
                            AppUserData.nickname = result.nickname
                            AppUserData.token = result.accessToken
                            AppUserData.refreshToken = result.refreshToken
                            observer(.success(()))
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

    func appleJoin(_ data: AppleJoin) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.appleJoin(model: data))
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let result = self.handleResponse(data, type: LoginResponse.self) {
                            AppUserData.nickname = result.nickname
                            AppUserData.profileImage = result.profileImage ?? ""
                            AppUserData.token = result.token.accessToken
                            AppUserData.refreshToken = result.token.refreshToken
                            observer(.success(()))
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

    func appleLogin(_ data: AppleLogin) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.appleLogin(model: data))
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let result = self.handleResponse(data, type: LoginResponse.self) {
                            AppUserData.nickname = result.nickname
                            AppUserData.profileImage = result.profileImage ?? ""
                            AppUserData.token = result.token.accessToken
                            AppUserData.refreshToken = result.token.refreshToken
                            observer(.success(()))
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

    func kakaoLogin(_ data: KakaoLogin) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.kakakLogin(model: data))
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let result = self.handleResponse(data, type: LoginResponse.self) {
                            AppUserData.nickname = result.nickname
                            AppUserData.profileImage = result.profileImage ?? ""
                            AppUserData.token = result.token.accessToken
                            AppUserData.refreshToken = result.token.refreshToken
                            observer(.success(()))
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

    func getUserLoginData() -> Single<Bool> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.getMyProfile)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let result = self.handleResponse(data, type: MyInfo.self) {
                            AppUserData.nickname = result.nickname
                            AppUserData.profileImage = result.profileImage ?? ""
                            observer(.success(true))
                        }
                    case .failure:
                        guard let statusCode = response.response?.statusCode, let data = response.data else {
                            observer(.failure(EndPointError.networkError))
                            return
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
