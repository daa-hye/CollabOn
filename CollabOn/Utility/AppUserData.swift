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
        case nickname
        case profileImage
        case token
        case refreshToken
        case currentWorkspace
    }

    @UserDafaultsManager(key: Key.userId.rawValue, defaultValue: 0)
    static var userId

    @UserDafaultsManager(key: Key.nickname.rawValue, defaultValue: "")
    static var nickname

    @UserDafaultsManager(key: Key.profileImage.rawValue, defaultValue: "")
    static var profileImage

    @UserDafaultsManager(key: Key.token.rawValue, defaultValue: "")
    static var token

    @UserDafaultsManager(key: Key.refreshToken.rawValue, defaultValue: "")
    static var refreshToken

    @UserDafaultsManager(key: Key.currentWorkspace.rawValue, defaultValue: 0)
    static var currentWorkspace

}
