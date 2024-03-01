//
//  StoreRouter.swift
//  CollabOn
//
//  Created by 박다혜 on 3/1/24.
//

import Foundation
import Alamofire

enum StoreRouter {
    case itemList
    case payValidation(imp: String?, merchant: String?)
}

extension StoreRouter: Router {

    var baseURL: URL? {
        return URL(string: SLP.baseURL)!.appendingPathComponent("/v1/store")
    }

    var path: String {
        switch self {
        case .itemList:
            return "/item/list"
        case .payValidation:
            return "/pay/validation"
        }
    }

    var header: HeaderType {
        switch self {
        case .itemList:
            return .withToken
        case .payValidation:
            return .jsonWithToken
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .itemList:
            return .get
        case .payValidation:
            return .post
        }
    }

    var parameters: RequestParams {
        switch self {
        case .itemList:
            return .none
        case .payValidation(let imp, let merchant):
            let body: [String: Any] = [
                "imp_uid": imp ?? "",
                "merchant_uid" : merchant ?? ""
            ]
            return .requestBody(body)
        }
    }

}

