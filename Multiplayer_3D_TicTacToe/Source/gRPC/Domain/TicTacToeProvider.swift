//
//  TicTacToeProvider.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 25/09/23.
//

import Foundation
import GRPC

final class TicTacToeProvider: Tictactoe_TicTacToeAsyncProvider {
    private(set) var gameFlowParameters: GameFlowParameters = GameFlowParameters.initialState
    private(set) var chatParameters: ChatParameters = ChatParameters(messages: [])
    
    func addPlayerInSession(request: Tictactoe_AddPlayerInSessionRequest, context: GRPC.GRPCAsyncServerCallContext) async throws -> Tictactoe_Player {
        var newPlayerStyle = TileStyle.randomStyle()
        
        if gameFlowParameters.players.contains(where: { $0.tileStyle == newPlayerStyle }) {
            if newPlayerStyle == .circle { newPlayerStyle = .cross }
            else if newPlayerStyle == .cross { newPlayerStyle = .circle }
        }
        
        let player = Player(
            id: gameFlowParameters.players.count,
            name: "Player \(gameFlowParameters.players.count)",
            tileStyle: newPlayerStyle,
            tiles: []
        )
        
        gameFlowParameters.players.append(player)
        
        let response = Tictactoe_Player.with {
            $0.id = Int64(player.id)
            $0.name = player.name
            $0.tileStyle = Tictactoe_TileStyle.init(rawValue: player.tileStyle == .cross ? 0 : 1)!
            $0.tiles = player.tiles.compactMap { value in
                Tictactoe_TilePosition.with {
                    $0.column = Int64(value.column)
                    $0.depth = Int64(value.depth)
                    $0.row = Int64(value.row)
                }
            }
        }
        
        return response
    }
    
    func selectStarterPlayer(request: Tictactoe_SelectStarterPlayerRequest, context: GRPC.GRPCAsyncServerCallContext) async throws -> Tictactoe_SelectStarterPlayerResponse {
        guard let starterPlayer = gameFlowParameters.players.randomElement() else { return Tictactoe_SelectStarterPlayerResponse() }
        gameFlowParameters.shiftPlayerId = starterPlayer.id
        
        return Tictactoe_SelectStarterPlayerResponse()
    }
    
    func startGame(request: Tictactoe_StartGameRequest, context: GRPC.GRPCAsyncServerCallContext) async throws -> Tictactoe_StartGameResponse {
        gameFlowParameters.gameStarted = true
        return Tictactoe_StartGameResponse()
    }
    
    func addTileOnBoard(request: Tictactoe_AddTileRequest, context: GRPC.GRPCAsyncServerCallContext) async throws -> Tictactoe_AddTileOnBoardResponse {
        guard let boardIndex = gameFlowParameters.boards.firstIndex(where: { $0.id == request.id }) else { return Tictactoe_AddTileOnBoardResponse() }
        gameFlowParameters.boards[boardIndex].tiles.append(
            Tile(
                boardId: Int(request.tile.boardID),
                style: request.tile.style.rawValue == 0 ? .cross : .circle
            )
        )
        return Tictactoe_AddTileOnBoardResponse()
    }
    
    func addTileToPlayer(request: Tictactoe_AddTileToPlayerRequest, context: GRPC.GRPCAsyncServerCallContext) async throws -> Tictactoe_AddTileToPlayerResponse {
        let position = request.tile.position
        guard let playerIndex = gameFlowParameters.players.firstIndex(where: { $0.id == request.player.id} )
        else { return Tictactoe_AddTileToPlayerResponse() }
        
        gameFlowParameters.players[playerIndex].tiles.append(
            TilePosition(row: Int(position.row), column: Int(position.column), depth: Int(position.depth))
        )
        gameFlowParameters.players[playerIndex].tiles.sort(by: { $0.depth < $1.depth })
        return Tictactoe_AddTileToPlayerResponse()
    }
    
    func changePlayerShift(request: Tictactoe_ChangePlayerShiftRequest, context: GRPC.GRPCAsyncServerCallContext) async throws -> Tictactoe_ChangePlayerShiftResponse {
        let currentPlayerId = gameFlowParameters.shiftPlayerId
        guard let nextPlayer = gameFlowParameters.players.first(where: { $0.id != currentPlayerId } ) else { return Tictactoe_ChangePlayerShiftResponse()}
        gameFlowParameters.shiftPlayerId = nextPlayer.id
        return Tictactoe_ChangePlayerShiftResponse()
    }
    
    func playerSurrender(request: Tictactoe_PlayerSurrenderRequest, context: GRPC.GRPCAsyncServerCallContext) async throws -> Tictactoe_PlayerSurrenderResponse {
        for sessionPlayer in gameFlowParameters.players {
            if sessionPlayer.id != request.player.id {
                gameFlowParameters.winner = sessionPlayer
                gameFlowParameters.gameEnded = true
                break
            }
        }
        return Tictactoe_PlayerSurrenderResponse()
    }
    
    func addChatMessage(request: Tictactoe_ChatMessageRequest, context: GRPC.GRPCAsyncServerCallContext) async throws -> Tictactoe_AddChatMessageResponse {
        chatParameters.messages.append(
            ChatMessage(
                sender: Player(
                    id: Int(request.sender.id),
                    name: request.sender.name,
                    tileStyle: request.sender.tileStyle.rawValue == 0 ? .cross : .circle,
                    tiles: request.sender.tiles.compactMap {
                        TilePosition(row: Int($0.row), column: Int($0.column), depth: Int($0.depth))
                    }
                ),
                message: request.incomingMessage,
                sendedDate: Date.now//request.sendedDate
            )
        )
        return Tictactoe_AddChatMessageResponse()
    }
    
    func didHaveAWinner(request: Tictactoe_DidHaveAWinnerRequest, context: GRPC.GRPCAsyncServerCallContext) async throws -> Tictactoe_WinningTiles {
        
        let rowPatterns = GameFlowParameters.rowWinPatterns
        let colPatterns = GameFlowParameters.colWinPatters
        let vertexPatterns = GameFlowParameters.vertexPatterns
        var winningTiles: [TilePosition] = []
        
        func verifyWinner(
            inputTiles: [TilePosition],
            pattern: [TilePosition],
            completion: ([TilePosition]?) -> Void
        ) {
            let allCases = pattern.compactMap { pattern in
                if inputTiles.contains(pattern) {
                    return pattern
                }
                return nil
            }
            if allCases.count > 2 { completion(pattern) }
        }
        
        for player in gameFlowParameters.players {
            if player.tiles.count < 3 { continue }
            
            rowPatterns.forEach {
                verifyWinner(
                    inputTiles: player.tiles,
                    pattern: $0,
                    completion: { tiles in
                        if let tiles = tiles {
                            winningTiles = tiles
                            gameFlowParameters.winner = player
                        }
                    }
                )
            }
            
            colPatterns.forEach {
                verifyWinner(
                    inputTiles: player.tiles,
                    pattern: $0,
                    completion: { tiles in
                        if let tiles = tiles {
                            winningTiles = tiles
                            gameFlowParameters.winner = player
                        }
                    }
                )
            }
            
            vertexPatterns.forEach {
                verifyWinner(
                    inputTiles: player.tiles,
                    pattern: $0,
                    completion: { tiles in
                        if let tiles = tiles {
                            winningTiles = tiles
                            gameFlowParameters.winner = player
                        }
                    }
                )
            }
            
            if !winningTiles.isEmpty {
                gameFlowParameters.gameEnded = true
                break
            }
        }
        
        let response = Tictactoe_WinningTiles.with {
            $0.tiles = winningTiles.compactMap { tile in
                Tictactoe_TilePosition.with {
                    $0.row = Int64(tile.row)
                    $0.column = Int64(tile.column)
                    $0.depth = Int64(tile.depth)
                }
            }
        }
        return response
    }
    
    func restartGame(request: Tictactoe_RestartGameRequest, context: GRPC.GRPCAsyncServerCallContext) async throws -> Tictactoe_RestartGameResponse {
        func resetPlayersTiles() {
            for i in 0..<gameFlowParameters.players.count {
                gameFlowParameters.players[i].tiles = []
            }
        }
        func resetBoardsTiles() {
            for i in 0..<gameFlowParameters.boards.count {
                gameFlowParameters.boards[i].tiles = []
            }
        }
        func resetGameParameters() {
            gameFlowParameters.winner = nil
            gameFlowParameters.gameStarted = false
            gameFlowParameters.gameEnded = false
        }
        
        resetPlayersTiles()
        resetBoardsTiles()
        resetGameParameters()
        
        return Tictactoe_RestartGameResponse()
    }
}
