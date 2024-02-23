//
//  UserRouter.swift
//  CollabOn
//
//  Created by 박다혜 on 1/7/24.
//

import Foundation
import Alamofire

enum UserRouter {
    case join(model: Join)
    case validationEmail(model: Email)
    case emailLogin(model: EmailLogin)
    case appleJoin(model: AppleJoin)
    case appleLogin(model: AppleLogin)
    case kakakLogin(model: KakaoLogin)
    case getMyProfile
    case deviceToken
}

extension UserRouter: Router {

    var baseURL: URL? {
        return URL(string: SLP.baseURL)!.appendingPathComponent("/v1/users")
    }

    var path: String {
        switch self {
        case .join:
            return "/join"
        case .validationEmail:
            return "/validation/email"
        case .emailLogin:
            return "/login"
        case .appleJoin, .appleLogin:
            return "/login/apple"
        case .kakakLogin:
            return "/login/kakao"
        case .getMyProfile:
            return "/my" 
        case .deviceToken:
            return "/deviceToken"
        }
    }

    var header: HeaderType {
        switch self {
        case .emailLogin, .appleJoin, .appleLogin, .kakakLogin, .join, .validationEmail:
            return .default
        case .getMyProfile, .deviceToken:
            return .withToken
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .emailLogin, .appleJoin, .appleLogin, .kakakLogin, .join, .validationEmail, .deviceToken:
            return .post
        case .getMyProfile:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .join(let model):
            let body: [String : Any] = [
                "email": model.email,
                "password": model.password,
                "nickname": model.nickname,
                "phone": model.phone ?? "",
                "deviceToken": AppUserData.deviceToken
            ]
            return .requestBody(body)

        case .validationEmail(let model):
            let body: [String: Any] = [
                "email": model.email
            ]
            return .requestBody(body)

        case .emailLogin(let model):
            let body: [String : Any] = [
                "email": model.email,
                "password": model.password,
                "deviceToken": AppUserData.deviceToken
            ]
            return .requestBody(body)

        case .appleJoin(let model):
            let body: [String: Any] = [
                "idToken": model.idToken,
                "nickname": model.nickname,
                "deviceToken": AppUserData.deviceToken
            ]
            return .requestBody(body)

        case .appleLogin(let model):
            let body: [String: Any] = [
                "idToken": model.idToken,
                "deviceToken": AppUserData.deviceToken
            ]
            return .requestBody(body)

        case.kakakLogin(let model):
            let body: [String: Any] = [
                "oauthToken": model.oauthToken,
                "deviceToken": AppUserData.deviceToken
            ]
            return .requestBody(body)

        case .deviceToken:
            let body: [String: Any] = [
                "deviceToken": AppUserData.deviceToken
            ]
            return .requestBody(body)

        case .getMyProfile:
            return .none
        }
    }

}
