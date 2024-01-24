//
//  Service.swift
//  CollabOn
//
//  Created by 박다혜 on 1/7/24.
//

import Foundation
import Alamofire

class Service {

    static let currentEnvironment: NetworkEnvironment = .development

    let AFManager: Session = {
        var session = AF
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = currentEnvironment.resourceTimeOut
        configuration.timeoutIntervalForResource = currentEnvironment.resourceTimeOut
        let interceptor = TokenErrorInterceptor()
        session = Session(configuration: configuration, interceptor: interceptor)
        return session
    }()

    func handleResponse<T: Decodable>(_ data: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(type, from: data) else { return nil }
        return decodedData
    }

    func handleError(statusCode: Int, _ data: Data) -> EndPointError {
        let decoder = JSONDecoder()
        switch statusCode {
        case 400:
            guard let error = try? decoder.decode(ErrorResponse.self, from: data),
                  let errorCode = EndPointError(rawValue: error.errorCode) else { return .undefinedError }
            return errorCode
        case 500:
            return .serverError
        default:
            return .networkError
        }
    }

}
