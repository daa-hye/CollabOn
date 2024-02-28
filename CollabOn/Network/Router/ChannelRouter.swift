//
//  ChannelRouter.swift
//  CollabOn
//
//  Created by 박다혜 on 2/19/24.
//

import Foundation
import Alamofire

enum ChannelRouter {
    case createChannel(id: Int, model: Channel)
    case getAllChannels(id: Int)
    case getMyChannels(id: Int)
    case getChannelByName(id: Int, name: String)
    case editChannel(id: Int, name: String, model: Channel)
    case deleteChannel(id: Int, name: String)
    case sendChannelChat(id: Int, name: String, model: Chats)
    case getChannelChats(id: Int, name: String, cursor: String)
    case getNumberOfUnreadChannelChats(id: Int, name: String, after: String?)
}

extension ChannelRouter: Router {

    var baseURL: URL? {
        return URL(string: SLP.baseURL)!.appendingPathComponent("/v1/workspaces")
    }

    var path: String {
        switch self {
        case .createChannel(let id, _), .getAllChannels(let id):
            return "/\(id)/channels"
        case .getMyChannels(let id):
            return "/\(id)/channels/my"
        case .getChannelByName(let id, let name), .editChannel(let id, let name, _), .deleteChannel(let id, let name):
            return "/\(id)/channels/\(name)"
        case .sendChannelChat(let id, let name, _), .getChannelChats(let id, let name, _):
            return "/\(id)/channels/\(name)/chats"
        case .getNumberOfUnreadChannelChats(let id, let name, _):
            return "/\(id)/channels/\(name)/unreads"
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .createChannel, .sendChannelChat:
            return .post
        case .getAllChannels, .getMyChannels, .getChannelByName, .getChannelChats, .getNumberOfUnreadChannelChats:
            return .get
        case .editChannel:
            return .put
        case .deleteChannel:
            return .delete
        }
    }

    var parameters: RequestParams {
        switch self {
        case .createChannel(_, let model), .editChannel(_, _, let model):
            let body: [String: Any] = [
                "name": model.name,
                "description" :model.description ?? ""
            ]
            return .requestBody(body)
        case .getAllChannels, .getMyChannels, .getChannelByName, .deleteChannel, .sendChannelChat:
            return .none
        case .getChannelChats(_,_,let cursor):
            let query: [String: String] = [
                "cursor_date" : cursor
            ]
            return .query(query)
        case .getNumberOfUnreadChannelChats(_,_,let after):
            let query: [String: String] = [
                "after" : after ?? ""
            ]
            return .query(query)
        }
    }

    var multipart: MultipartFormData {
        switch self {
        case .sendChannelChat(_,_, let model):
            let multiPart = MultipartFormData()

            let content = model.content.data(using: .utf8) ?? Data()
            let files = model.files

            multiPart.append(content, withName: "content")
            for file in files {
                multiPart.append(file, withName: "files", fileName: "\(Date()).jpeg", mimeType: "image/jpeg")
            }
            return multiPart
        default:
            return MultipartFormData()
        }
    }
    
}
