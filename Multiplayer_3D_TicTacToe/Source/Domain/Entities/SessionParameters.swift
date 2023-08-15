//
//  SessionParameters.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 15/08/23.
//

import Foundation

struct SessionParameters: Codable {
    var players: [Player]
    var starterPlayerId: Int
    var gameStarted: Bool
    var boards: [Board] = Board.generateBoards()
    
    static let initialState: SessionParameters = {
        let parameters = SessionParameters(players: [], starterPlayerId: 0, gameStarted: false)
        return parameters
    }()
}
