//
//  WorkspaceModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/15/24.
//

import Foundation

struct WorkspaceResponse: Decodable {
    let workspaceId: Int
    let name: String
    let description: String
    let thumbnail: String
    let ownerId: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case name
        case description
        case thumbnail
        case ownerId = "owner_id"
        case createdAt
    }
}

struct WorkspaceDetail: Decodable, Hashable {
    let workspaceId: Int
    let name: String
    let description: String
    let thumbnail: String
    let ownerId: Int
    let createdAt: String
    let channels: [Channel]
    let workspaceMembers: [Member]

    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case name
        case description
        case thumbnail
        case ownerId = "owner_id"
        case createdAt
        case channels
        case workspaceMembers
    }
}

struct Channel: Decodable, Hashable {
    let workspaceId: Int
    let channelId: Int
    let name: String
    let description: String
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

struct Member: Decodable, Hashable {
    let userId: Int
    let email: String
    let nickname: String
    let profileImage: String?
}

struct Workspace: Encodable {
    let name: String
    let description: String
    let image: Data
}
