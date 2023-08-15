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
        sessionParameters.starterPlayerId = starterPlayer.id
    }
    
    func startGame() {
        sessionParameters.gameStarted = true
    }
}
