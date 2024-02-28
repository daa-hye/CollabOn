//
//  ChannelManager.swift
//  CollabOn
//
//  Created by 박다혜 on 2/27/24.
//

import Foundation
import RxSwift
import RxRelay

class ChannelManager {

    private let channel: ChannelResponse

    init(_ channel: ChannelResponse) {
        self.channel = channel
    }

    private let repository = ChannelRepository()
    let chatList = ReplayRelay<[ChannelChat]>.create(bufferSize: 1)

    func getChatList() {
        var chats: [ChannelChat] = []
        let list = repository.getChats(channel.channelId)

        if let list = list, !list.isEmpty {
            for item in list {
                chats.append(item)
            }
            chatList.accept(chats)
        } else {
            getChatListFromServer()
        }
    }

    func getChatListFromServer() {
        repository.insertChannel(channel: channel)
        _ = ChannelService.shared.getChannelChats(id: channel.workspaceId, name: channel.name, cursor: "")
            .filter { !$0.isEmpty }
            .subscribe(with: self) { owner, chats in
                owner.repository.insertChats(owner.channel.channelId, chats)
            }

        var chats: [ChannelChat] = []
        let list = repository.getChats(channel.channelId)

        if let list = list, !list.isEmpty {
            for item in list {
                chats.append(item)
            }
            chatList.accept(chats)
        }
    }

    func addChat(_ chat: ChatResponse) {
        repository.insertChat(channel.channelId, chat)
        getChatList()
    }

}
