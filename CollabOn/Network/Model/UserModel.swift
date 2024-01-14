//
//  UserModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/8/24.
//

import Foundation

struct EmailLogin: Encodable {
    let email: String
    let password: String
    let deviceToken: String?
}

struct EmailLoginResponse: Decodable {
    let nickname: String
    let accessToken: String
    let refreshToken: String
}

struct AppleJoin: Decodable {
    let idToken: String
    let nickname: String
    let deviceToken: String?
}

struct AppleLogin: Decodable {
    let idToken: String
    let deviceToken: String?
}

struct KakaoLogin: Decodable {
    let oauthToken: String
    let deviceToken: String?
}

struct LoginResponse: Decodable {
    let nickname: String
    let profileImage: String?
    let token: Token
}

struct Join: Encodable {
    let email: String
    let password: String
    let nickname: String
    let phone: String?
    let deviceToken: String?
}

struct Email: Encodable {
    let email: String
}

struct Token: Decodable, Hashable {
    let accessToken: String
    let refreshToken: String
}
