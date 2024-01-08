//
//  UserDafaultsManager.swift
//  CollabOn
//
//  Created by 박다혜 on 1/8/24.
//

import Foundation

@propertyWrapper
struct UserDafaultsManager<T> {

    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }

}
