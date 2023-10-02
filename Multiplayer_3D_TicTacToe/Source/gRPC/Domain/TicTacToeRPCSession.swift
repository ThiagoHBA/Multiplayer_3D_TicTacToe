//
//  TicTacToeSession.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 08/08/23.
//

import Foundation

final class TicTacToeRPCSession: Session {
    private(set) var chatParameters: ChatParameters = ChatParameters(messages: [])
    private(set) var gameFlowParameters: GameFlowParameters = GameFlowParameters.initialState
    
    func addPlayerInSession() -> Player {
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
        return player
    }
    
    func selectStarterPlayer() {
        guard let starterPlayer = gameFlowParameters.players.randomElement() else { return }
        gameFlowParameters.shiftPlayerId = starterPlayer.id
    }
    
    func startGame() {
        gameFlowParameters.gameStarted = true
    }
    
    func addTileOnBoard(with id: Int, tile: Tile) {
        guard let boardIndex = gameFlowParameters.boards.firstIndex(where: { $0.id == id }) else { return }
        gameFlowParameters.boards[boardIndex].tiles.append(tile)
    }
    
    func addTileToPlayer(player: Player, tile: Tile) {
        guard let position = tile.position else { return }
        guard let playerIndex = gameFlowParameters.players.firstIndex(where: { $0.id == player.id} )
        else { return }
        
        gameFlowParameters.players[playerIndex].tiles.append(position)
        gameFlowParameters.players[playerIndex].tiles.sort(by: { $0.depth < $1.depth })
    }
    
    func changePlayerShift() {
        let currentPlayerId = gameFlowParameters.shiftPlayerId
        guard let nextPlayer = gameFlowParameters.players.first(where: { $0.id != currentPlayerId } ) else { return }
        gameFlowParameters.shiftPlayerId = nextPlayer.id
    }
    
    func playerSurrender(_ player: Player) {
        for sessionPlayer in gameFlowParameters.players {
            if sessionPlayer.id != player.id {
                gameFlowParameters.winner = sessionPlayer
                gameFlowParameters.gameEnded = true
                break
            }
        }
    }
    
    func addChatMessage(_ message: ChatMessage) {
        chatParameters.messages.append(message)
    }

    func didHaveAWinner() -> [TilePosition] {
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
        
        return winningTiles
    }
    
    func restartGame() {
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
    }
}
