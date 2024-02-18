//
//  UserManager.swift
//  CollabOn
//
//  Created by 박다혜 on 2/18/24.
//

import Foundation
import RxSwift
import RxRelay

class UserManager {

    static let shared = UserManager()

    private init() {}

    var userInfo = ReplayRelay<MyInfo?>.create(bufferSize: 1)

    func fetchUser() {
        _ = UserService.shared.getUserLoginData()
            .catch { _ in
                return Single<MyInfo?>.just(nil)
            }
            .subscribe { value in
                self.userInfo.accept(value)
            }
    }

}
