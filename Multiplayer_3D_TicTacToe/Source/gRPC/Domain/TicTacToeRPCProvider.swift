//
//  TicTacToeProvider.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 25/09/23.
//

import Foundation
import GRPC
import NIO


final class TicTacToeProvider: Tictactoe_TicTacToeProvider {
    var session = TicTacToeRPCSession()
    var interceptors: Tictactoe_TicTacToeServerInterceptorFactoryProtocol?
    var output: ClientOutput?
    
    func connectedMessage(
        request: Tictactoe_ConnectMessageRequest,
        context: GRPC.StatusOnlyCallContext
    ) -> NIOCore.EventLoopFuture<Tictactoe_ConnectMessageResponse> {
        let hostPlayer = session.addPlayerInSession()
        let secondPlayer = session.addPlayerInSession()
        
        let response = Tictactoe_ConnectMessageResponse.with {
            $0.connected = true
            $0.hostPlayer = hostPlayer.toGRPCEntity()
            $0.identifier = secondPlayer.toGRPCEntity()
            $0.parameters = session.gameFlowParameters.toGRPCEntity()
        }
        
        output?.didConnectInServer(hostPlayer)
        output?.didConnectAPlayer(with: Int(request.port))
        output?.didUpdateSessionParameters(session.gameFlowParameters)
        
        return context.eventLoop.makeSucceededFuture(response)
    }    
    
    func startGame(
        request: Tictactoe_StartGameRequest,
        context: GRPC.StatusOnlyCallContext
    ) -> NIOCore.EventLoopFuture<Tictactoe_StartGameResponse> {
        session.selectStarterPlayer()
        session.startGame()
        
        let response = Tictactoe_StartGameResponse.with {
            $0.starterPlayerID = Int64(session.gameFlowParameters.shiftPlayerId)
            $0.parameters = session.gameFlowParameters.toGRPCEntity()
        }
        
        output?.didUpdateSessionParameters(session.gameFlowParameters)
        output?.didGameStart()
        output?.didChangeShift(session.gameFlowParameters.shiftPlayerId)
        
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    func playerMove(
        request: Tictactoe_PlayerMoveRequest,
        context: GRPC.StatusOnlyCallContext
    ) -> NIOCore.EventLoopFuture<Tictactoe_PlayerMoveResponse> {
        session.addTileOnBoard(
            with: Int(request.boardID),
            tile: Tile(from: request.addedTile)
        )
        session.addTileToPlayer(
            player: Player(from: request.player),
            tile: Tile(from: request.addedTile)
        )
        
        let winningTiles = session.didHaveAWinner()
    
        if !winningTiles.isEmpty {
            if let winner = session.gameFlowParameters.winner {
                output?.didEndGame(winner, surrender: false, winningTiles: winningTiles)
                output?.didUpdateSessionParameters(session.gameFlowParameters)
            }
        } else {
            session.changePlayerShift()
            output?.didChangeShift(session.gameFlowParameters.shiftPlayerId)
            output?.didUpdateSessionParameters(session.gameFlowParameters)
        }
        
        let response = Tictactoe_PlayerMoveResponse.with {
            $0.success = true
            $0.winningTiles = winningTiles.compactMap { $0.toGRPCEntity() }
            $0.parameters = session.gameFlowParameters.toGRPCEntity()
        }
        
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    func chatMessage(
        request: Tictactoe_ChatMessageRequest,
        context: GRPC.StatusOnlyCallContext
    ) -> NIOCore.EventLoopFuture<Tictactoe_ChatMessageResponse> {
        let message = ChatMessage(from: request.chatMessage)
        session.addChatMessage(message)
        output?.didReceiveAChatMessage(message)
        
        let response = Tictactoe_ChatMessageResponse.with {
            $0.success = true
            $0.chatParameters = session.chatParameters.toGRPCEntity()
        }
        
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    func surrender(
        request: Tictactoe_SurrenderRequest,
        context: GRPC.StatusOnlyCallContext
    ) -> NIOCore.EventLoopFuture<Tictactoe_SurrenderResponse> {
        session.playerSurrender(Player(from: request.player))
        let winner = session.gameFlowParameters.winner!
        output?.didEndGame(
            winner,
            surrender: true,
            winningTiles: []
        )
        output?.didUpdateSessionParameters(session.gameFlowParameters)
        
        let response = Tictactoe_SurrenderResponse.with {
            $0.winner = winner.toGRPCEntity()
            $0.parameters = session.gameFlowParameters.toGRPCEntity()
        }
        
        return context.eventLoop.makeSucceededFuture(response)
    }
    
    func restartGame(
        request: Tictactoe_RestartGameRequest,
        context: GRPC.StatusOnlyCallContext
    ) -> NIOCore.EventLoopFuture<Tictactoe_StartGameResponse> {
        session.restartGame()
        return self.startGame(request: .init(), context: context)
    }
}
