//
//  AuthService.swift
//  CollabOn
//
//  Created by 박다혜 on 1/8/24.
//

import Foundation
import Alamofire

class AuthService: Service {

    static let shared = AuthService()

    private override init() {}

}

extension AuthService {

    func join(_ data: Join, completion: @escaping (Result<Bool, EndPointError>) -> Void) {
        AFManager.request(AuthRouter.join(model: data))
            .responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.data else { return completion(.failure(.undefinedError)) }
                let result = self.handleResponse(statusCode: statusCode, data, type: JoinResponse.self)
                switch result {
                case .success(let value):
                    guard let value = value else { return completion(.failure(.undefinedError)) }
                    AppUserData.nickname = value.nickname
                    AppUserData.profileImage = value.profileImage ?? ""
                    AppUserData.token = value.token.accessToken
                    AppUserData.token = value.token.refreshToken
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            case .failure(_):
                completion(.failure(.undefinedError))
            }
        }
    }

    func validateEmail(_ data: Email, completion: @escaping (Result<Bool, EndPointError>) -> Void) {
        AFManager.request(AuthRouter.validationEmail(model: data))
            .response { response in
            switch response.result {
            case .success(_):
                guard let statusCode = response.response?.statusCode else { return }
                let result = self.handleResponse(statusCode: statusCode, response.data)
                switch result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(.networkError))
                print(error)
            }
        }
    }

}
