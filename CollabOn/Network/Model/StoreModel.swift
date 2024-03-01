//
//  StoreModel.swift
//  CollabOn
//
//  Created by 박다혜 on 3/1/24.
//

import Foundation

struct ItemResponse: Decodable {
    let item: String
    let amount: String
}

struct PaymentResponse: Decodable {
    let billingId: Int
    let merchantUid: String
    let amount: Int
    let sesacCoin: Int
    let success: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case billingId = "billing_id"
        case merchantUid = "merchant_uid"
        case amount
        case sesacCoin
        case success
        case createdAt
    }
}
