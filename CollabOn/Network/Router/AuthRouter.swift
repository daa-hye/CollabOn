//
//  AuthRouter.swift
//  CollabOn
//
//  Created by 박다혜 on 1/14/24.
//

import Foundation
import Alamofire

enum AuthRouter {
    case refreshToken
}

extension AuthRouter: Router {

    var baseURL: URL? {
        return URL(string: SLP.baseURL)!.appendingPathComponent("/v1/auth")
    }

    var path: String {
        switch self {
        case .refreshToken:
            return "/refresh"
        }
    }

    var header: HeaderType {
        switch self {
        case .refreshToken:
            return .refreshToken
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .refreshToken:
            return .get
        }
    }

    var parameters: RequestParams {
        switch self {
        case .refreshToken:
            return .none
        }
    }

}
