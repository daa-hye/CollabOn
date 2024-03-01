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
                .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let value):
                    AppUserData.token = value.token.accessToken
                    AppUserData.refreshToken = value.token.refreshToken
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
                .responseDecodable(of: EmailLoginResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        AppUserData.userId = value.userId
                        AppUserData.token = value.accessToken
                        AppUserData.refreshToken = value.refreshToken
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

    func appleJoin(_ data: AppleJoin) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.appleJoin(model: data))
                .responseDecodable(of: LoginResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        AppUserData.userId = value.userId
                        AppUserData.token = value.token.accessToken
                        AppUserData.refreshToken = value.token.refreshToken
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

    func appleLogin(_ data: AppleLogin) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.appleLogin(model: data))
                .responseDecodable(of: LoginResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        AppUserData.userId = value.userId
                        AppUserData.token = value.token.accessToken
                        AppUserData.refreshToken = value.token.refreshToken
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

    func kakaoLogin(_ data: KakaoLogin) -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.kakakLogin(model: data))
                .responseDecodable(of: LoginResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        AppUserData.userId = value.userId
                        AppUserData.token = value.token.accessToken
                        AppUserData.refreshToken = value.token.refreshToken
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

    func getUserLoginData() -> Single<MyInfo?> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.getMyProfile)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: MyInfo.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(value))
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

    func deviceToken() -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(UserRouter.deviceToken)
                .validate(statusCode: 200..<300)
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
