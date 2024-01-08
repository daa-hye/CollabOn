//
//  HeaderType.swift
//  CollabOn
//
//  Created by 박다혜 on 1/7/24.
//

import Foundation

@frozen enum HeaderType {
    case withToken
    case multipartWithToken
    case `default`
}

@frozen enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case auth = "Authorization"
}

@frozen enum HTTPHeaderContent: String {
    case json = "application/json"
    case multipart = "multipart/form-data"
}
