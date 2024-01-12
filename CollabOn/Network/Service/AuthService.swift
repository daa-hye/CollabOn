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

    func emailLogin(_ data: EmailLogin) -> Single<Bool> {
        Single.create { observer in
            let request = self.AFManager.request(AuthRouter.emailLogin(model: data))
                .responseData { response in
                    switch response.result {
                    case .success:
                        guard let statusCode = response.response?.statusCode else { return }
                        guard let data = response.data else { return observer(.failure(EndPointError.undefinedError)) }
                        let result = self.handleResponse(statusCode: statusCode, data, type: EmailLoginResponse.self)
                        switch result {
                        case .success(let value):
                            guard let value = value else {  return observer(.failure(EndPointError.undefinedError)) }
                            AppUserData.nickname = value.nickname
                            AppUserData.token = value.accessToken
                            AppUserData.token = value.refreshToken
                            observer(.success(true))
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

    func join(_ data: Join) -> Single<Bool> {
        Single.create { observer in
            let request = self.AFManager.request(AuthRouter.join(model: data))
                .responseData { response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let data = response.data else { return observer(.failure(EndPointError.undefinedError)) }
                    let result = self.handleResponse(statusCode: statusCode, data, type: LoginResponse.self)
                    switch result {
                    case .success(let value):
                        guard let value = value else {  return observer(.failure(EndPointError.undefinedError)) }
                        AppUserData.nickname = value.nickname
                        AppUserData.profileImage = value.profileImage ?? ""
                        AppUserData.token = value.token.accessToken
                        AppUserData.token = value.token.refreshToken
                        observer(.success(true))
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

    func validateEmail(_ data: Email) -> Single<Bool> {
        Single.create { observer in
            let request = self.AFManager.request(AuthRouter.validationEmail(model: data))
                .response { response in
                switch response.result {
                case .success(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    let result = self.handleResponse(statusCode: statusCode, response.data)
                    switch result {
                    case .success(let value):
                        observer(.success(value))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                case .failure(let error):
                    observer(.failure(EndPointError.networkError))
                    print(error)
                }
            }

            return Disposables.create {
                request.cancel()
            }
            
        }
    }

}
