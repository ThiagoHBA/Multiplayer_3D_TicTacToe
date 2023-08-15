//
//  TicTacToeSession.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 08/08/23.
//

import Foundation

final class TicTacToeSession: Session {
    var sessionParameters: SessionParameters = SessionParameters.initialState
     
    func addPlayerInSession() -> Player {
        var newPlayerStyle = TileStyle.randomStyle()
        
        if sessionParameters.players.contains(where: { $0.tileStyle == newPlayerStyle }) {
            if newPlayerStyle == .circle { newPlayerStyle = .cross }
            else if newPlayerStyle == .cross { newPlayerStyle = .circle }
        }
        
        let player = Player(
            id: sessionParameters.players.count,
            name: "Player \(sessionParameters.players.count)",
            tileStyle: newPlayerStyle,
            tiles: []
        )
        
        sessionParameters.players.append(player)
        return player
    }
    
    func selectStarterPlayer() {
        guard let starterPlayer = sessionParameters.players.randomElement() else { return }
        sessionParameters.shiftPlayerId = starterPlayer.id
    }
    
    func startGame() {
        sessionParameters.gameStarted = true
    }
    
    func addTileOnBoard(with id: Int, tile: Tile) {
        sessionParameters.boards[id].tiles.append(tile)
    }
    
    func changePlayerShift() {
        let currentPlayerId = sessionParameters.shiftPlayerId
        guard let nextPlayer = sessionParameters.players.first(where: { $0.id != currentPlayerId } ) else { return }
        sessionParameters.shiftPlayerId = nextPlayer.id
    }
}
