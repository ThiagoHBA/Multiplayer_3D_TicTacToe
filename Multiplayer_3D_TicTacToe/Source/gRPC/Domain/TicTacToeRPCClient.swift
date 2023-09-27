//
//  TicTacToeRPCClient.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 25/09/23.
//

import Foundation
import GRPC
import NIO

class TicTacToeRPCClient {
    var port: Int = 8080
    var clientOutput: ClientOutput?
    
    private var group: MultiThreadedEventLoopGroup!
    var service: Tictactoe_TicTacToeNIOClient!
    
    init() {
        group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    }
    
    deinit {
        do {
            try group.syncShutdownGracefully()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension TicTacToeRPCClient: Client {
    func connectToServer(url: URL) {
        let target = ConnectionTarget.hostAndPort(url.absoluteString, port)
        let configuration: ClientConnection.Configuration = .default(target: target, eventLoopGroup: group)
        let connection = ClientConnection(configuration: configuration)
        service = Tictactoe_TicTacToeNIOClient(channel: connection)
    }
    
    func disconnectToServer() {
        //
    }
    
    func sendMessage(_ message: TransferMessage) {
        switch message.type {
            case .client(let clientMessage):
                sendClientMessages(clientMessage)
            case .server(_):
                break
            }
    }
    
    func handleMessageFromServer(_ message: TransferMessage) {
        //
    }
    
    func sendClientMessages(_ message: MessageType.ClientMessages) {
        switch message {
            case .gameFlow(let gameFlowMessage):
                switch gameFlowMessage {
                    case .playerMove:
                    case .playerSurrender:
                    case .playAgain:
                }
            case .chat(let chatMessage):
            
        }
    }
}
