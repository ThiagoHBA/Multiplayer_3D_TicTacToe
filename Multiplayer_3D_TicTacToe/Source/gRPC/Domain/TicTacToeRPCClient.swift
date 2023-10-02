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
    var service: Tictactoe_TicTacToeNIOClient!
    private var group: MultiThreadedEventLoopGroup!
    
    init(completion: @escaping () -> ()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
            completion()
        }
    }
    
    deinit {
        do {
            try group.syncShutdownGracefully()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func connectToService(port: Int, completion: @escaping () -> ()) {
        let target = ConnectionTarget.hostAndPort("localhost", port)
        let configuration: ClientConnection.Configuration = .default(target: target, eventLoopGroup: group)
        let connection = ClientConnection(configuration: configuration)
        self.service = Tictactoe_TicTacToeNIOClient(channel: connection)
        completion()
    }
}

//extension TicTacToeRPCClient: Client {
//    
//    func disconnectToServer() {
//        //
//    }
//    
//    func sendChatStreamMessage() async {
//        let chatCall = service.makeChatCall()
//        let message = Tictactoe_Message.with {
//            $0.text = "Message: \(Int.random(in: 0..<100))"
//            $0.identifier = .with {
//                $0.id = 1
//                $0.name = "Player"
//                $0.tileStyle = .circle
//                $0.tiles = []
//            }
//        }
//       
//        do {
//            try await chatCall.requestStream.send(message)
//            
//            for try await message in chatCall.responseStream {
//                print(message.text)
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func sendConnectedMessage() async -> Tictactoe_ConnectedMessageResponse {
//        let request = Tictactoe_ConnectedMessageRequest.with {
//            $0.connected = true
//            $0.identifier = .with {
//                $0.id = 1
//                $0.name = "Player"
//                $0.tileStyle = .circle
//                $0.tiles = []
//            }
//        }
//        do {
//            let response = try await service.connectedMessage(request)
//            print("RECEIVING RESPONSE IN CLIENT: \(response)")
//            return response
//        } catch {
//            print(error.localizedDescription)
//        }
//        return Tictactoe_ConnectedMessageResponse()
//    }
//    
//    func sendMessage(_ message: TransferMessage) async {
//        switch message.type {
//            case .client(let clientMessage):
//               await sendClientMessages(message, clientMessage)
//            case .server(_):
//                break
//            }
//    }
//    
//    func sendClientMessages(_ message: TransferMessage,_ type: MessageType.ClientMessages) async {
//        switch type {
//            case .connection(_):
//                do {
//                    let message = try await service.connectedMessage(
//                        Tictactoe_ConnectedMessageRequest()
//                    )
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .gameFlow(let gameFlowMessage):
//                switch gameFlowMessage {
//                    case .playerMove:
//                        break
//                    case .playerSurrender:
//                        break
//                    case .playAgain:
//                        break
//                }
//            case .chat(_):
//                break
//        }
//    }
//        
//    func handleMessageFromServer(_ message: TransferMessage) {
//        //
//    }
//}
