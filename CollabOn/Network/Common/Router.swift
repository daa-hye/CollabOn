//
//  Router.swift
//  CollabOn
//
//  Created by 박다혜 on 1/7/24.
//

import Foundation
import Alamofire

protocol Router: URLRequestConvertible {

    var baseURL: URL? { get }
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
        let url = baseURL!.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request = makeHeader(for: request)
        return try makeParameter(for: request)
    }

    func makeHeader(for request: URLRequest) -> URLRequest {
        
        var request = request

        switch header {
        case .withToken:
            request.setValue(SLP.key, forHTTPHeaderField: HTTPHeaderField.key.rawValue)
            request.setValue(AppUserData.token, forHTTPHeaderField: HTTPHeaderField.auth.rawValue)
        case .jsonWithToken:
            request.setValue(HTTPHeaderContent.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            request.setValue(SLP.key, forHTTPHeaderField: HTTPHeaderField.key.rawValue)
            request.setValue(AppUserData.token, forHTTPHeaderField: HTTPHeaderField.auth.rawValue)
        case .multipartWithToken:
            request.setValue(HTTPHeaderContent.multipart.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            request.setValue(SLP.key, forHTTPHeaderField: HTTPHeaderField.key.rawValue)
            request.setValue(AppUserData.token, forHTTPHeaderField: HTTPHeaderField.auth.rawValue)
        case .refreshToken:
            request.setValue(SLP.key, forHTTPHeaderField: HTTPHeaderField.key.rawValue)
            request.setValue(AppUserData.token, forHTTPHeaderField: HTTPHeaderField.auth.rawValue)
            request.setValue(AppUserData.refreshToken, forHTTPHeaderField: HTTPHeaderField.refreshToken.rawValue)
        case .default:
            request.setValue(HTTPHeaderContent.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            request.setValue(SLP.key, forHTTPHeaderField: HTTPHeaderField.key.rawValue)
        }

        return request

    }

    func makeParameter(for request: URLRequest) throws -> URLRequest {

        var request = request

        switch parameters {
        case .query(let query):
            request = try URLEncodedFormParameterEncoder(destination: .queryString).encode(query, into: request)
        case .requestBody(let body):
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        case .queryAndBody(let query, let body):
            request = try URLEncodedFormParameterEncoder(destination: .queryString).encode(query, into: request)
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        case .none:
            break
        }

        return request
    }

}

extension Router {

    var baseURL: URL? {
        return URL(string: SLP.baseURL)
    }

    var header: HeaderType {
        return HeaderType.withToken
    }

    var multipart: MultipartFormData {
        return MultipartFormData()
    }

}

enum RequestParams {
    case query(_ query: [String : String])
    case requestBody(_ body: [String : Any])
    case queryAndBody(query: [String : String], body: [String : Any])
    case none
}
