//
//  RPCManager.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 30/09/23.
//

import Foundation
import GRPC

class RPCManager {
    static var shared = RPCManager()
    var client: TicTacToeRPCClient!
    var server: TicTacToeRPCServer!
    weak var clientOutput: ClientOutput?
    
    private init() {
        DispatchQueue.global(qos: .background).async {
            self.client = TicTacToeRPCClient(completion: {})
            self.server = TicTacToeRPCServer()
        }
    }
    
    public func run(handler: @escaping (Int) -> ()) {
        if let server = server {
            guard !server.isRunning else {
                handler(server.port)
                return
            }
            DispatchQueue.global(qos: .background).async {
                self.server.run { port in
                    handler(port)
                }
            }
        }
    }
    
    func sendConnectedMessage(port: Int) async {
        do {
            let request = Tictactoe_ConnectMessageRequest.with { $0.port = Int64(port) }
            let response = try await client.service.connectedMessage(request).response.get()
            let parameters = GameFlowParameters(from: response.parameters)
            server.provider.session.updateGameFlowParameters(parameters)
            clientOutput?.didConnectInServer(Player(from: response.identifier))
            clientOutput?.didUpdateSessionParameters(parameters)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func sendStartGameMessage(_ request: Tictactoe_StartGameRequest) async {
        do {
            let response = try await client.service.startGame(request).response.get()
            let parameters = GameFlowParameters(from: response.parameters)
            server.provider.session.updateGameFlowParameters(parameters)
            clientOutput?.didUpdateSessionParameters(parameters)
            clientOutput?.didGameStart()
            clientOutput?.didChangeShift(Int(response.parameters.shiftPlayerID))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func sendPlayerMoveMessage(_ request: Tictactoe_PlayerMoveRequest) async {
        do {
            let response = try await client.service.playerMove(request).response.get()
            let parameters = GameFlowParameters(from: response.parameters)
            server.provider.session.updateGameFlowParameters(parameters)
            if !response.winningTiles.isEmpty {
                clientOutput?.didEndGame(
                    parameters.winner!,
                    surrender: false,
                    winningTiles: response.winningTiles.compactMap { TilePosition(from: $0) }
                )
            } else {
                clientOutput?.didChangeShift(Int(response.parameters.shiftPlayerID))
            }
            clientOutput?.didUpdateSessionParameters(parameters)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func sendChatMessage(_ request: Tictactoe_ChatMessageRequest) async {
        do {
            let response = try await client.service.chatMessage(request).response.get()
            let parameters = ChatParameters(from: response.chatParameters)
            server.provider.session.updateChatParameters(parameters)
            clientOutput?.didUpdateChatParameters(parameters)
        } catch {
            print(error.localizedDescription)
        }
    }

}
    
