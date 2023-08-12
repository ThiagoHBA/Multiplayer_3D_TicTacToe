//
//  TicTacToeGameServer.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 04/08/23.
//

import Foundation
import Network

final class TicTacToeServer: Server {
    var listener: NWListener
    var connectedClients: [NWConnection] = []
    var gameSession: Session = TicTacToeSession()
    weak var output: ServerOutput?
    
    init(port: UInt16 = 8080) throws {
        /// An object that stores the protocols to use for connections, options for sending data, and network path constraints.
        let parameters = NWParameters()
        parameters.defaultProtocolStack.transportProtocol = NWProtocolTCP.Options()
        /// Default WebSocket protocol options
        let webSocketOptions = NWProtocolWebSocket.Options()
        /// Inserting options in application protocols stack
        parameters.defaultProtocolStack.applicationProtocols.insert(webSocketOptions, at: 0)
        
        do {
             if let port = NWEndpoint.Port(rawValue: port) {
                listener = try NWListener(using: parameters, on: port)
            } else {
                throw WebSocketError.unableToStartInPort(port)
            }
        } catch {
            throw WebSocketError.unableToInitializeListener
        }
    }
    
    func startServer(completion: @escaping (WebSocketError?) -> Void) {
        let serverQueue = DispatchQueue(label: "ServerQueue")
        
        listener.newConnectionHandler = { newConnection in
            self.connectedClients.append(newConnection)
            newConnection.receiveMessage { completeContent, contentContext, isComplete, error in
                print("RECEIVE MESSAGE CALLBACK")
            }
            newConnection.stateUpdateHandler = { state in
                switch state {
                    case .waiting(_):
                        completion(.connectTimeWasTooLong)
                    case .ready:
                        let newPlayer = self.gameSession.createPlayer()
                        self.gameSession.players.append(newPlayer)
                        self.output?.didConnectAPlayer(newPlayer)
                        self.sendMessageToClient(
                            message: TransferMessage.connectedMessage,
                            client: newConnection,
                            completion: { _ in }
                        )
                        completion(nil)
                    case .failed(_):
                        completion(.cantConnectWithClient)
                    default:
                        break
                }
            }
            
            newConnection.start(queue: serverQueue)
        }
        
        listener.stateUpdateHandler = { state in
            switch state {
                case .ready:
                    completion(nil)
                case .failed(let error):
                    completion(.serverInitializationFail(error.localizedDescription))
                default:
                    break
            }
        }
        
        listener.start(queue: serverQueue)
        let player = gameSession.createPlayer()
        gameSession.players.append(player)
        output?.didStartServer(player)
    }
    
    func sendMessageToClient(
        message: TransferMessage,
        client: NWConnection,
        completion: @escaping (WebSocketError?) -> Void
    ) {
        let metadata = NWProtocolWebSocket.Metadata(opcode: .binary)
        let context = NWConnection.ContentContext(identifier: "context", metadata: [metadata])
        
        do {
            let messageData = try message.encodeToTransfer()
            client.send(
                content: messageData,
                contentContext: context,
                isComplete: true,
                completion: .contentProcessed( { error in
                    if let _ = error {
                        completion(.unableToSendAMessageToUser)
                    } else {
                        completion(nil)
                    }
            }))
            completion(nil)
        } catch {
            completion(.unableToEncodeMessage)
        }
    }
    
    func sendMessageToAllClients(_ message: Data) {
        
    }
}

