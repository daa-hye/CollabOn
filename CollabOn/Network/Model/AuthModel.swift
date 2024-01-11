//
//  AuthModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/8/24.
//

import Foundation

struct Join: Encodable {
    let email: String
    let password: String
    let nickname: String
    let phone: String?
    let deviceToken: String?
}

struct JoinResponse: Decodable {
    let nickname: String
    let profileImage: String?
    let token: Token
}

struct Email: Encodable {
    let email: String
}

struct Token: Decodable, Hashable {
    let accessToken: String
    let refreshToken: String
}
