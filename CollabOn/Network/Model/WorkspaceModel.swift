//
//  WorkspaceModel.swift
//  CollabOn
//
//  Created by 박다혜 on 1/15/24.
//

import Foundation

struct WorkspaceResponse: Decodable, Equatable {
    let workspaceId: Int
    let name: String
    let description: String
    let thumbnail: URL?
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.workspaceId = try container.decode(Int.self, forKey: .workspaceId)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.ownerId = try container.decode(Int.self, forKey: .ownerId)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)

        let imagePath = try container.decode(String.self, forKey: .thumbnail)
        if let url = URL(string: "\(SLP.baseURL)/v1\(imagePath)") {
            self.thumbnail = url
        } else {
            self.thumbnail = nil
        }
    }
}

struct WorkspaceDetail: Decodable, Hashable {
    let workspaceId: Int
    let name: String
    let description: String
    let thumbnail: URL?
    let ownerId: Int
    let createdAt: String
    let channels: [ChannelResponse]
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

    init() {
        self.workspaceId = 0
        self.name = ""
        self.description = ""
        self.thumbnail = nil
        self.ownerId = 0
        self.createdAt = ""
        self.channels = []
        self.workspaceMembers = []
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.workspaceId = try container.decode(Int.self, forKey: .workspaceId)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.ownerId = try container.decode(Int.self, forKey: .ownerId)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.channels = try container.decode([ChannelResponse].self, forKey: .channels)
        self.workspaceMembers = try container.decode([Member].self, forKey: .workspaceMembers)

        let imagePath = try container.decode(String.self, forKey: .thumbnail)
        if let url = URL(string: "\(SLP.baseURL)/v1\(imagePath)") {
            self.thumbnail = url
        } else {
            self.thumbnail = nil
        }
    }

}

struct Workspace: Encodable {
    let name: String
    let description: String
    let image: Data
}
