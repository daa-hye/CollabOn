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
        session = Session(configuration: configuration)
        return session
    }()

    func handleResponse<T: Decodable>(statusCode: Int, _ data: Data, type: T.Type) -> Result<T, EndPointError> {
        let decoder = JSONDecoder()
        switch statusCode {
        case 200:
            guard let decodedData = try? decoder.decode(EndPointResponse<T>.self, from: data) else { return .failure(.nonExistentData) }
            return .success(decodedData as! T)
        case 400:
            guard let error = try? decoder.decode(ErrorResponse.self, from: data),
                    let errorCode = EndPointError(rawValue: error.errorCode) else { return .failure(.nonExistentData) }
            return .failure(errorCode)
        default:
            return .failure(.networkError)
        }
    }

}
