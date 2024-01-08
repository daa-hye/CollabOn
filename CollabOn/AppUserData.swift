//
//  AppUserData.swift
//  CollabOn
//
//  Created by 박다혜 on 1/8/24.
//

import Foundation

enum AppUserData {

    enum Key: String {
        case token
        case refreshToken
    }

    @UserDafaultsManager(key: Key.token.rawValue, defaultValue: "")
    static var token

    @UserDafaultsManager(key: Key.refreshToken.rawValue, defaultValue: "")
    static var refreshToken

}
