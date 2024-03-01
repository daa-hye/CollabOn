//
//  ChannelManager.swift
//  CollabOn
//
//  Created by 박다혜 on 2/27/24.
//

import Foundation
import SocketIO
import RxSwift
import RxRelay

final class ChannelManager {

    private let channel: ChannelResponse

    private let repository = ChannelRepository()
    let chatList = ReplayRelay<[ChannelChat]>.create(bufferSize: 1)

    private let url: URL
    private let manager: SocketManager
    private let socket: SocketIOClient

    init(_ channel: ChannelResponse) {
        self.channel = channel
        url = URL(string: "\(SLP.baseURL)/ws-channel-\(channel.channelId)")!
        manager = SocketManager(socketURL: url, config: [.compress])
        socket = manager.socket(forNamespace: "/ws-channel-\(channel.channelId)")

        getChatList()
    }

}

extension ChannelManager {

    func getChatList() {
        if let lastConnect = repository.getLastConnect(channel.channelId) {
            getChatListFromServer(lastConnect)
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

    func getChatListFromServer(_ cursor: String) {
        _ = ChannelService.shared.getChannelChats(id: channel.workspaceId, name: channel.name, cursor: cursor)
            .filter { !$0.isEmpty }
            .subscribe(on: MainScheduler.instance)
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
        var chats: [ChannelChat] = []
        let list = repository.getChats(channel.channelId)

        if let list = list, !list.isEmpty {
            for item in list {
                chats.append(item)
            }
            chatList.accept(chats)
        }
    }

    func saveLastConnect(_ time: String) {
        repository.saveLastConnect(channel.channelId, time: time)
    }

}

extension ChannelManager {

    func socketConnect() {

        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
        }

        socket.on("channel") { [weak self] dataArray, ack in

            let data = dataArray.first
            guard let data else { return }
            let json = try? JSONSerialization.data(withJSONObject: data)
            let decoder = JSONDecoder()
            let decodeData = try? decoder.decode(ChatResponse.self, from: json ?? Data())

            if let chat = decodeData {
                self?.addChat(chat)
            }
        }

        socket.connect()
    }

    func socketDisconnect() {
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
    }

}
