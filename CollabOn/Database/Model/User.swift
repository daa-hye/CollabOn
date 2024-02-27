//
//  User.swift
//  CollabOn
//
//  Created by 박다혜 on 2/26/24.
//

import Foundation
import RealmSwift

final class User: EmbeddedObject {
    @Persisted var id: Int
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?

    convenience init(id: Int, email: String, nickname: String, profileImage: String?) {
        self.init()

        self.id = id
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
}
