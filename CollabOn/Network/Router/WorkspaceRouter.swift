//
//  WorkspaceRouter.swift
//  CollabOn
//
//  Created by 박다혜 on 1/15/24.
//

import Foundation
import Alamofire

enum WorkspaceRouter {
    case createWorkspace(model: Workspace)
    case getAllWorkspaces
    case getWorkspaceById(id: Int)
}

extension WorkspaceRouter: Router {

    var baseURL: URL? {
        return URL(string: SLP.baseURL)!.appendingPathComponent("/v1/workspaces")
    }

    var path: String {
        switch self {
        case .createWorkspace, .getAllWorkspaces:
            return ""
        case .getWorkspaceById(let id):
            return "/\(id)"
        }
    }

    var header: HeaderType {
        switch self {
        case .createWorkspace:
            return .multipartWithToken
        case .getAllWorkspaces, .getWorkspaceById:
            return .withToken
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .createWorkspace:
            return .post
        case .getAllWorkspaces, .getWorkspaceById:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .createWorkspace, .getAllWorkspaces, .getWorkspaceById:
            return .none
        }
    }

    var multipart: MultipartFormData {
        switch self {
        case .createWorkspace(let model):
            let multiPart = MultipartFormData()

            let name = model.name.data(using: .utf8) ?? Data()
            let description = model.description.data(using: .utf8) ?? Data()
            let image = model.image

            multiPart.append(name, withName: "name")
            multiPart.append(description, withName: "description")
            multiPart.append(image, withName: "image", fileName: "\(Date()).jpeg", mimeType: "image/jpeg")

            return multiPart
        default:
            return MultipartFormData()
        }
    }

}
