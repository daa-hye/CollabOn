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
    let userId: Int
    let nickname: String
    let accessToken: String
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nickname
        case accessToken
        case refreshToken
    }
}

struct AppleJoin: Encodable {
    let idToken: String
    let nickname: String
    let deviceToken: String?
}

struct AppleLogin: Encodable {
    let idToken: String
    let deviceToken: String?
}

struct KakaoLogin: Encodable {
    let oauthToken: String
    let deviceToken: String?
}

struct LoginResponse: Decodable {
    let userId: Int
    let nickname: String
    let profileImage: String?
    let token: Token

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nickname
        case profileImage
        case token
    }
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

struct MyInfo: Decodable {
    let email: String
    let nickname: String
    let profileImage: URL?
    let phone: String?
    let vendor: String?
    let sesacCoin: Int
    let createdAt: String

    enum CodingKeys: CodingKey {
        case email
        case nickname
        case profileImage
        case phone
        case vendor
        case sesacCoin
        case createdAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decode(String.self, forKey: .email)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.vendor = try container.decodeIfPresent(String.self, forKey: .vendor)
        self.sesacCoin = try container.decode(Int.self, forKey: .sesacCoin)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)

        if let imagePath = try container.decodeIfPresent(String.self, forKey: .profileImage) {
            let url = URL(string: "\(SLP.baseURL)/v1\(imagePath)")
            self.profileImage = url
        } else {
            self.profileImage = nil
        }
    }
}
