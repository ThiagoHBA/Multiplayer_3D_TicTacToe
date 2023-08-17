//
//  TicTacToeSession.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 08/08/23.
//

import Foundation

final class TicTacToeSession: Session {
    var chatParameters: ChatParameters = ChatParameters(messages: [])
    var gameFlowParameters: GameFlowParameters = GameFlowParameters.initialState
     
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
}
