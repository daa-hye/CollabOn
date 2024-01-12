//
//  NetworkConstants.swift
//  CollabOn
//
//  Created by 박다혜 on 1/7/24.
//

import Foundation

enum NetworkEnvironment {

    case development
    case production

    var requestTimeinterval: TimeInterval {
        switch self {
        case .development:
            return 5.0
        case .production:
            return 10.0
        }
    }

    var resourceTimeOut:TimeInterval {
        switch self {
        case .development:
            return 5.0
        case .production:
            return 10.0
        }
    }
    
}

enum EndPointError: String, Error {

    case keyRequired = "E01"
    case AuthorizationFailed = "E02"
    case unknownUser = "E03"
    case tokenExpired = "E05"
    case invalidInput = "E11"
    case duplicateData = "E12"
    case nonExistentData = "E13"
    case permissionDenied = "E14"
    case requestDenied = "E15"
    case insufficientCoins = "E21"
    case existingPaymentCase = "E81"
    case invalidPaymentCase = "E82"
    case serverError = "E99"
    case networkError
    case undefinedError

}
