//
//  AuthRouter.swift
//  CollabOn
//
//  Created by 박다혜 on 1/7/24.
//

import Foundation
import Alamofire

enum AuthRouter {
    case emailLogin(model: EmailLogin)
    case join(model: Join)
    case validationEmail(model: Email)
}

extension AuthRouter: Router {

    var path: String {
        switch self {
        case .emailLogin: 
            return "/v1/users/login"
        case .join:
            return "/v1/users/join"
        case .validationEmail:
            return "/v1/users/validation/email"
        }
    }

    var header: HeaderType {
        switch self {
        case .emailLogin, .join, .validationEmail:
            return .default
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .emailLogin, .join, .validationEmail:
            return .post
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .emailLogin(let model):
            let body: [String : Any] = [
                "email": model.email,
                "password": model.password
            ]
            return .requestBody(body)
            
        case .join(let model):
            let body: [String : Any] = [
                "email": model.email,
                "password": model.password,
                "nickname": model.nickname,
                "phone": model.phone ?? "",
                "deviceToken": model.deviceToken ?? ""
            ]
            return .requestBody(body)

        case .validationEmail(let model):
            let body: [String: Any] = [
                "email": model.email
            ]
            return .requestBody(body)
        }
    }

}
