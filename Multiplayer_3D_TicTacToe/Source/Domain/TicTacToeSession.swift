//
//  TicTacToeSession.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 08/08/23.
//

import Foundation

final class TicTacToeSession: Session {
    
    var players: [Player] = []
    
    func createPlayer() -> Player {
        var newPlayerStyle = TileStyle.randomStyle()
        
        if players.contains(where: { $0.tileStyle == newPlayerStyle }) {
            if newPlayerStyle == .circle { newPlayerStyle = .cross }
            else if newPlayerStyle == .cross { newPlayerStyle = .circle }
        }
        
        let player = Player(
            id: players.count,
            name: "Player \(players.count)",
            tileStyle: newPlayerStyle,
            tiles: []
        )
        
        return player
    }
}
