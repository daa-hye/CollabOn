//
//  Extension + NSObject.swift
//  CollabOn
//
//  Created by 박다혜 on 1/24/24.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
