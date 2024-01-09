//
//  AuthRouter.swift
//  CollabOn
//
//  Created by 박다혜 on 1/7/24.
//

import Foundation
import Alamofire

enum AuthRouter {
    case join(model: Join)
    case validationEmail(model: Email)
}

extension AuthRouter: Router {

    var path: String {
        switch self {
        case .join:
            return "/v1/users/join"
        case .validationEmail:
            return "/v1/users/validation/email"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .join, .validationEmail:
            return .post
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .join(let model):
            let body: [String : String] = [
                "email": model.email,
                "password": model.password,
                "nickname": model.nickname,
                "phone": model.phone ?? "",
                "deviceToken": model.deviceToken ?? ""
            ]
            return .requestParameters(body)

        case .validationEmail(let model):
            let body: [String: String] = [
                "email": model.email
            ]
            return .requestParameters(body)
        }
    }

}
