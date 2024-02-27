//
//  ChannelChat.swift
//  CollabOn
//
//  Created by 박다혜 on 2/26/24.
//

import Foundation
import RealmSwift

final class ChannelChat: Object {
    @Persisted(originProperty: "chats") var channel: LinkingObjects<ChannelObject>

    @Persisted(primaryKey: true) var chatId: Int
    @Persisted var content: String?
    @Persisted var createdAt: Date
    @Persisted var files: List<File>
    @Persisted var user: User?

    convenience init(chatId: Int, content: String? = nil, createdAt: Date, files: List<File>) {
        self.init()
        
        self.channel = channel
        self.chatId = chatId
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.channel = channel
    }
}

extension ChatResponse {
    func convertToObject() -> ChannelChat {
        let list = List<File>()
        let member = self.user
        let image = member.profileImage != nil ? String(describing: member.profileImage) : nil
        let user = User(id: member.userId, email: member.email, nickname: member.nickname, profileImage: image)

        for url in self.files {
            let file = File()
            file.path = String(describing: url)
            list.append(file)
        }

        let chat = ChannelChat.init(chatId: self.chatId, content: self.content, createdAt: self.createdAt.convertToDate(), files: list)
        chat.user = user
        return chat
    }

}
