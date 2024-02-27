//
//  ChannelObject.swift
//  CollabOn
//
//  Created by 박다혜 on 2/26/24.
//

import Foundation
import RealmSwift

final class ChannelObject: Object {
    @Persisted(primaryKey: true) var channelId: Int
    @Persisted var channelName: String
    @Persisted var chats: List<ChannelChat>
    @Persisted var lastConnection: String?

    convenience init(channelId: Int, channelName: String, lastConnection: String?) {
        self.init()
        
        self.channelId = channelId
        self.channelName = channelName
        self.lastConnection = lastConnection
    }
}

extension ChannelResponse {

    func convertToObject() -> ChannelObject {
        return ChannelObject(channelId: self.channelId, channelName: self.name, lastConnection: nil)
    }

}
