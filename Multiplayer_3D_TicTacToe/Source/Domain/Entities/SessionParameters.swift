//
//  SessionParameters.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 15/08/23.
//

import Foundation

struct SessionParameters: Codable {
    var players: [Player]
    var shiftPlayerId: Int
    var gameStarted: Bool
    var boards: [Board] = Board.generateBoards()
    var winner: Player? = nil
    
    static let initialState: SessionParameters = {
        let parameters = SessionParameters(players: [], shiftPlayerId: 0, gameStarted: false)
        return parameters
    }()
}
