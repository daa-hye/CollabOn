//
//  AppUserData.swift
//  CollabOn
//
//  Created by 박다혜 on 1/8/24.
//

import Foundation

enum AppUserData {

    enum Key: String {
        case userId
        case token
        case refreshToken
        case currentWorkspace
        case deviceToken
    }

    @UserDafaultsManager(key: Key.userId.rawValue, defaultValue: 0)
    static var userId

    @UserDafaultsManager(key: Key.token.rawValue, defaultValue: "")
    static var token

    @UserDafaultsManager(key: Key.refreshToken.rawValue, defaultValue: "")
    static var refreshToken

    @UserDafaultsManager(key: Key.currentWorkspace.rawValue, defaultValue: 0)
    static var currentWorkspace

    @UserDafaultsManager(key: Key.deviceToken.rawValue, defaultValue: "")
    static var deviceToken

}
