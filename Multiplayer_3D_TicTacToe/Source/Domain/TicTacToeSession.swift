//
//  TicTacToeSession.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 08/08/23.
//

import Foundation

final class TicTacToeSession: Session {
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
        guard let playerIndex = gameFlowParameters.players.firstIndex(where: { $0.id == player.id} ) else { return }
        
        gameFlowParameters.players[playerIndex].tiles.append(position)
        
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
        var winningTiles: [TilePosition] = []
        
        for player in gameFlowParameters.players {
            print("Player \(player.name) tiles: \(player.tiles)")
            
            rowPatterns.forEach {
                if player.tiles.contains($0) {
                    winningTiles = $0
                    gameFlowParameters.winner = player
                }
            }
            
            colPatterns.forEach {
                if player.tiles.contains($0) {
                    winningTiles = $0
                    gameFlowParameters.winner = player
                }
            }
            
            if !winningTiles.isEmpty { break }
        }
        
        return winningTiles
    }
}
