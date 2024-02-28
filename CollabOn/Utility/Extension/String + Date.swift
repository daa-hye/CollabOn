//
//  String + Date.swift
//  CollabOn
//
//  Created by 박다혜 on 2/27/24.
//

import Foundation

extension String {

    func convertToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.date(from: self) ?? Date()
    }

}
