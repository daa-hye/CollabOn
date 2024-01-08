//
//  Router.swift
//  CollabOn
//
//  Created by 박다혜 on 1/7/24.
//

import Foundation
import Alamofire

protocol Router: URLRequestConvertible {

    var baseURL: String { get }
    var path: String { get }
    var header: HeaderType { get }
    var method: HTTPMethod { get }
    var parameters: RequestParams { get }
    var multipart: MultipartFormData { get }

    func makeHeader(for request: URLRequest) -> URLRequest
    func makeParameter(for request: URLRequest) throws -> URLRequest

}

extension Router {

    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var request = try URLRequest(url: url.appending(path: path), method: method)
        request = makeHeader(for: request)
        return try makeParameter(for: request)
    }

    func makeHeader(for request: URLRequest) -> URLRequest {
        
        var request = request

        switch header {
        case .withToken:
            request.setValue(HTTPHeaderContent.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            request.setValue(SLP.key, forHTTPHeaderField: HTTPHeaderField.auth.rawValue)
        case .multipartWithToken:
            request.setValue(HTTPHeaderContent.multipart.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            request.setValue(SLP.key, forHTTPHeaderField: HTTPHeaderField.auth.rawValue)
        case .default:
            request.setValue(HTTPHeaderContent.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }

        return request

    }

    func makeParameter(for request: URLRequest) throws -> URLRequest {

        var request = request

        switch parameters {
        case .query(let query):
            request = try URLEncodedFormParameterEncoder(destination: .queryString).encode(query, into: request)
        case .body(let body):
            request = try URLEncodedFormParameterEncoder(destination: .httpBody).encode(body, into: request)
        case .requestParameters(let requestParams):
            request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(requestParams, into: request)
        }

        return request
    }

}

extension Router {

    var baseURL: String {
        return SLP.baseURL
    }

    var header: HeaderType {
        return HeaderType.withToken
    }

    var multipart: MultipartFormData {
        return MultipartFormData()
    }

}

enum RequestParams {
    case query(_ parameter: Codable)
    case body(_ parameter: Codable)
    case requestParameters(_ parameter: [String : String])
}
