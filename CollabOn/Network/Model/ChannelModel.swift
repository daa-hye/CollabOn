//
//  ChannelModel.swift
//  CollabOn
//
//  Created by 박다혜 on 2/19/24.
//

import Foundation

struct ChannelResponse: Decodable, Hashable {
    let workspaceId: Int
    let channelId: Int
    let name: String
    let description: String?
    let ownerId: Int
    let `private`: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case channelId = "channel_id"
        case name
        case description
        case `private`
        case ownerId = "owner_id"
        case createdAt
    }

}

struct ChannelDetail: Decodable {
    let workspaceId: Int
    let channelId: Int
    let name: String
    let description: String?
    let ownerId: Int
    let `private`: Int
    let createdAt: String
    let channelMembers: [Member]

    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case channelId = "channel_id"
        case name
        case description
        case `private`
        case ownerId = "owner_id"
        case createdAt
        case channelMembers
    }
}

struct Member: Decodable, Hashable {
    let userId: Int
    let email: String
    let nickname: String
    let profileImage: URL?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickname
        case profileImage
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.email = try container.decode(String.self, forKey: .email)
        self.nickname = try container.decode(String.self, forKey: .nickname)

        let imagePath  = try container.decode(String?.self, forKey: .profileImage)
        if let imagePath = imagePath, let url = URL(string: "\(SLP.baseURL)/v1\(imagePath)") {
            self.profileImage = url
        } else {
            self.profileImage = nil
        }
    }
}

struct ChatResponse: Decodable {
    let channelId: Int
    let channelName: String
    let chatId: Int
    let content: String?
    let createdAt: String
    let files: [URL]
    let user: Member

    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case channelName
        case chatId = "chat_id"
        case content
        case createdAt
        case files
        case user
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.channelId = try container.decode(Int.self, forKey: .channelId)
        self.channelName = try container.decode(String.self, forKey: .channelName)
        self.chatId = try container.decode(Int.self, forKey: .chatId)
        self.content = try container.decode(String.self, forKey: .content)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.user = try container.decode(Member.self, forKey: .user)

        let paths = try container.decode([String].self, forKey: .files)
        var urls: [URL] = []

        for path in paths {
            if let url = URL(string: "\(SLP.baseURL)/v1\(path)") {
                urls.append(url)
            }
        }

        self.files = urls
    }

}

struct Channel: Encodable {
    let name: String
    let description: String?
}

struct Chats: Encodable {
    let content: String
    let files: [Data]
}
