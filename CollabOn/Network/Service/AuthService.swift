//
//  AuthService.swift
//  CollabOn
//
//  Created by 박다혜 on 1/14/24.
//

import Foundation
import Alamofire
import RxSwift

final class AuthService: Service {
 
    static let shared = AuthService()

    private override init() {}

}

extension AuthService {

    func refreshToken() -> Single<Void> {
        Single.create { observer in
            let request = self.AFManager.request(AuthRouter.refreshToken)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let result = self.handleResponse(data, type: RefreshTokenResponse.self) {
                            AppUserData.token = result.accessToken
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

}
