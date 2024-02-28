//
//  ChannelChattingViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 2/23/24.
//

import Foundation
import RxSwift
import RxRelay
import SocketIO

class ChannelChattingViewModel: ViewModelType {

    let input: Input
    let output: Output

    private let channel: ChannelResponse

    private lazy var channelManager = ChannelManager(channel)
    private lazy var url = URL(string: "\(SLP.baseURL)/ws-channel-{\(channel.channelId)}")!
    //private lazy var manager = SocketManager(socketURL: url, config: [.log(true), .compress])
    //private lazy var socket = manager.defaultSocket

    private let chatText = PublishSubject<String>()
    private let file = PublishSubject<Data>()
    private var files: [Data] = []
    private let sendButtonDidTap = PublishSubject<Void>()

    private let chatList = ReplayRelay<[ChannelChat]>.create(bufferSize: 1)

    let disposeBag = DisposeBag()

    struct Input {
        let chatText: AnyObserver<String>
        let file: AnyObserver<Data>
        let sendButtonDidTap: AnyObserver<Void>
    }

    struct Output {
        let chatList: Observable<[ChannelChat]>
    }

    init(_ channel: ChannelResponse) {
        self.channel = channel

        input = .init(
            chatText: chatText.asObserver(),
            file: file.asObserver(),
            sendButtonDidTap: sendButtonDidTap.asObserver()
        )

        output = .init(
            chatList: chatList.observe(on: MainScheduler.instance)
        )

        file.bind(with: self) { owner, data in
            owner.files.append(data)
        }
        .disposed(by: disposeBag)

        channelManager.chatList
            .bind(to: chatList)
            .disposed(by: disposeBag)

        channelManager.getChatList()

        sendButtonDidTap
            .withLatestFrom(chatText)
            .withUnretained(self)
            .flatMapLatest { owner, chat in
                return ChannelService.shared.sendChannelChat(id: channel.workspaceId, name: channel.name, model: Chats(content: chat, files: owner.files ))
                    .asObservable()
                    .materialize()
            }
            .subscribe(with: self) { owner, event in
                switch event {
                case .next(let value):
                    owner.channelManager.addChat(value)
                case .error(let error):
                    print(error)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

//        socket.connect()
//
//        socket.on(clientEvent: .connect) { data, ack in
//            print("SOCKET IS CONNECTED", data, ack)
//        }
//
//
//        socket.on("channel") { dataArray, ack in
//            print("CHANNEL RECEIVED", dataArray, ack)
//        }
    }

//    deinit {
//        socket.on(clientEvent: .disconnect) { data, ack in
//            print("SOCKET IS DISCONNECTED", data, ack)
//        }
//    }



}
