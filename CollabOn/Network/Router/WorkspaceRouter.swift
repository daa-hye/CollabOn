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
    case editWorkspace(id: Int, model: Workspace)
    case deleteWorkspace(id: Int)
    case addWorkspaceMember(id: Int, model: Email)
    case getAllMembers(id: Int)
    case getMemberById(id: Int, userId: Int)
    //case searchInWorkspace
    case leaveWorkspace(id: Int)
    case changeWorkspaceAdmin(id: Int, userId: Int)
}

extension WorkspaceRouter: Router {

    var baseURL: URL? {
        return URL(string: SLP.baseURL)!.appendingPathComponent("/v1/workspaces")
    }

    var path: String {
        switch self {
        case .createWorkspace, .getAllWorkspaces:
            return ""
        case .getWorkspaceById(let id), .editWorkspace(let id, _), .deleteWorkspace(let id):
            return "/\(id)"
        case .addWorkspaceMember(let id, _), .getAllMembers(let id):
            return "/\(id)/members"
        case .getMemberById(let id, let userId):
            return "/\(id)/members/\(userId)"
        case .leaveWorkspace(let id):
            return "/\(id)/leave"
        case .changeWorkspaceAdmin(let id, let userId):
            return "/\(id)/change/admin/\(userId)"
        }
    }

    var header: HeaderType {
        switch self {
        case .createWorkspace, .editWorkspace:
            return .multipartWithToken
        case .getAllWorkspaces, .getWorkspaceById, .deleteWorkspace, .getAllMembers, .getMemberById, .leaveWorkspace, .changeWorkspaceAdmin:
            return .withToken
        case .addWorkspaceMember:
            return .jsonWithToken
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .createWorkspace, .addWorkspaceMember:
            return .post
        case .getAllWorkspaces, .getWorkspaceById, .getAllMembers, .getMemberById, .leaveWorkspace:
            return .get
        case .editWorkspace, .changeWorkspaceAdmin:
            return .put
        case .deleteWorkspace:
            return .delete
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .createWorkspace, .getAllWorkspaces, .getWorkspaceById, .editWorkspace,
                .deleteWorkspace, .getAllMembers, .getMemberById, .leaveWorkspace, .changeWorkspaceAdmin:
            return .none
        case .addWorkspaceMember(_, let model):
            let body: [String: Any] = [
                "email": model.email
            ]
            return .requestBody(body)
        }
    }

    var multipart: MultipartFormData {
        switch self {
        case .createWorkspace(let model), .editWorkspace(_, let model):
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
