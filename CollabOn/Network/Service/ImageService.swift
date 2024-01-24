//
//  ImageService.swift
//  CollabOn
//
//  Created by 박다혜 on 1/24/24.
//

import Foundation
import Kingfisher

final class ImageService: Service {
    static let shared = ImageService()
    private override init() {}
}

extension ImageService {

    func getImage() -> AnyModifier {
        return AnyModifier { request in
            var request = request
            request.setValue(AppUserData.token, forHTTPHeaderField: HTTPHeaderField.auth.rawValue)
            request.setValue(SLP.key, forHTTPHeaderField: HTTPHeaderField.key.rawValue)
            return request
        }
    }

}
