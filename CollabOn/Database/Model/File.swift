//
//  File.swift
//  CollabOn
//
//  Created by 박다혜 on 2/26/24.
//

import Foundation
import RealmSwift

final class File: EmbeddedObject {
    @Persisted var path: String
}
