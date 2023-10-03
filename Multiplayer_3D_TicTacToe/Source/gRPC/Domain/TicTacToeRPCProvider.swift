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
            let response = Tictactoe_PlayerMoveResponse.with {
                $0.success = true
                $0.parameters = session.gameFlowParameters.toGRPCEntity()
            }
            output?.didChangeShift(session.gameFlowParameters.shiftPlayerId)
            output?.didUpdateSessionParameters(session.gameFlowParameters)
            return context.eventLoop.makeSucceededFuture(response)
        }
        
        return context.eventLoop.makeSucceededFuture(.init())
    }
}