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
    var serverURL: URL {
        let processInfo = ProcessInfo()
        return URL(string: "ws://\(processInfo.hostName):8080")!
    }
    
    init(port: UInt16 = 8080) throws {
        /// An object that stores the protocols to use for connections, options for sending data, and network path constraints.
        let parameters = NWParameters()
        parameters.allowLocalEndpointReuse = true
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
            self.didReceiveAConnection(newConnection, completion: { _ in })
            newConnection.stateUpdateHandler = { state in
                switch state {
                    case .waiting(_):
                        completion(.connectTimeWasTooLong)
                    case .ready:
                        let newPlayer = self.gameSession.addPlayerInSession()
                        self.sendMessageToClient(
                            message: TransferMessage.getConnectedMessage(identifier: newPlayer),
                            client: newConnection,
                            completion: { _ in }
                        )
                        self.sendMessageToAllClients(
                            TransferMessage.updateSessionParametersMessage(
                                newState: self.gameSession.gameFlowParameters
                            )
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
    
    private func didReceiveAConnection(
        _ connection: NWConnection,
        completion: @escaping (WebSocketError?) -> Void
    ) {
        connection.receiveMessage { [weak self] (data, context, isComplete, error) in
            if let data = data {
                self?.handleMessageFromClient(
                    data: data,
                    connection: connection
                )
                self?.didReceiveAConnection(connection, completion: completion)
            }
        }
    }
    
    func sendMessageToAllClients(_ message: TransferMessage) {
        for client in connectedClients {
            sendMessageToClient(message: message, client: client) { _ in }
        }
    }
    
    func startGame() {
        gameSession.selectStarterPlayer()
        gameSession.startGame()
        self.sendMessageToAllClients(
            TransferMessage.getGameStartedMessage(value: true)
        )
        self.sendMessageToAllClients(
            TransferMessage.getChangeShiftMessage(
                gameSession.gameFlowParameters.shiftPlayerId
            )
        )
        self.sendMessageToAllClients(
            TransferMessage.updateSessionParametersMessage(
                newState: self.gameSession.gameFlowParameters
            )
        )
    }
    
    func handleMessageFromClient(data: Data, connection: NWConnection) {
        guard let transferMessage = try? JSONDecoder().decode(TransferMessage.self, from: data) else {
            return
        }
        switch transferMessage.type{
            case .server(_): break
            case .client(let clientMessage):
                switch clientMessage {
                    case .gameFlow(let gameFlowMessage):
                        handleGameFlowMessages(transferMessage, gameFlowMessage)
                }
        }
    }
    
    func handleGameFlowMessages(
        _ message: TransferMessage,
        _ source: MessageType.ClientMessages.ClientGameFlow
    ) {
        switch source {
            case .playerMove:
                    let playerMovementMessage = try! JSONDecoder().decode(
                        PlayerMoveDTO.self,
                        from: message.data
                    )
                    let boardId = playerMovementMessage.boardId
                    let tile = playerMovementMessage.addedTile
            
                    gameSession.addTileOnBoard(with: boardId, tile: tile)
                    gameSession.changePlayerShift()
                    sendMessageToAllClients(
                        TransferMessage.getEndPlayerMoveMessage(boardId: boardId, tile: tile)
                    )
                    sendMessageToAllClients(
                        TransferMessage.getChangeShiftMessage(
                            gameSession.gameFlowParameters.shiftPlayerId
                        )
                    )
                    sendMessageToAllClients(
                        TransferMessage.updateSessionParametersMessage(
                            newState: gameSession.gameFlowParameters
                        )
                    )
            case .playerSurrender:
                let playerSurrenderDTO = try! JSONDecoder().decode(
                    PlayerSurrenderDTO.self,
                    from: message.data
                )
                gameSession.playerSurrender(playerSurrenderDTO.player)
                guard let winner = gameSession.gameFlowParameters.winner else { return }
                sendMessageToAllClients(TransferMessage.getGameEndMessage(winner))
                sendMessageToAllClients(
                    TransferMessage.updateSessionParametersMessage(
                        newState: gameSession.gameFlowParameters
                    )
                )
        }
    }
}

