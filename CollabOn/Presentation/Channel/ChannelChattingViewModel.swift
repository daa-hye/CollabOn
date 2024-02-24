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

    private let channelId: Int
    private lazy var url = URL(string: "\(SLP.baseURL)/ws-channel-{\(channelId)}")!
    private lazy var manager = SocketManager(socketURL: url, config: [.log(true), .compress])
    private lazy var socket = manager.defaultSocket

    let disposeBag = DisposeBag()

    struct Input {

    }

    struct Output {

    }

    init(_ id: Int) {
        channelId = id
        
        input = .init()
        output = .init()

        socket.connect()

        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
        }


        socket.on("channel") { dataArray, ack in
            print("CHANNEL RECEIVED", dataArray, ack)
        }
    }

    deinit {
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
    }



}
