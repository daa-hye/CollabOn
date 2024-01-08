//
//  EndPointResponse.swift
//  CollabOn
//
//  Created by 박다혜 on 1/8/24.
//

import Foundation

struct EndPointResponse<T> {
    let data: T?

    enum CodingKeys: String, CodingKey {
            case data
    }
}

extension EndPointResponse: Decodable where T: Decodable  {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try? container.decode(T.self, forKey: .data)
    }
}

struct ErrorResponse: Decodable {
    let errorCode: String
}
