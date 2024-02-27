//
//  ChannelRepository.swift
//  CollabOn
//
//  Created by 박다혜 on 2/26/24.
//

import Foundation
import RealmSwift

final class ChannelRepository {
   
    private var realm: Realm?

    init() {
        do {
            realm = try Realm()
        } catch let error {
            print(error.localizedDescription)
        }
        print(realm!.configuration.fileURL)
    }

    private func fetch(_ id: Int) -> ChannelObject? {
        guard let realm else { return nil }
        let channel = realm.object(ofType: ChannelObject.self, forPrimaryKey: id)
        return channel
    }

    func insertChannel(channel: ChannelResponse) {
        guard let realm else { return }
        do {
            try realm.write {
                realm.add(channel.convertToObject(), update: .modified)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func getChats(_ id: Int) -> List<ChannelChat>? {
        guard let chats = fetch(id)?.chats else { return nil }
        return chats
    }

    func insertChat(_ id: Int, _ chat: ChatResponse) {
        guard let realm, let object = fetch(id) else { return }
        do {
            try realm.write {
                object.lastConnection = chat.createdAt
                object.chats.append(chat.convertToObject())
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func insertChats(_ id: Int, _ chats: [ChatResponse]) {
        guard let realm, let object = fetch(id) else { return }
        for chat in chats {
            do {
                try realm.write {
                    object.chats.append(chat.convertToObject())
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }

        do {
            try realm.write {
                object.lastConnection = chats.last?.createdAt
            }
        } catch let error {
            print(error.localizedDescription)
        }

    }

}
