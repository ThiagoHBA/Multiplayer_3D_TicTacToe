//
//  SessionParameters.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 15/08/23.
//

import Foundation

struct GameFlowParameters: DTO {
    var players: [Player]
    var shiftPlayerId: Int
    var gameStarted: Bool
    var boards: [Board] = Board.generateBoards()
    var winner: Player? = nil
    
    static let initialState: GameFlowParameters = {
        let parameters = GameFlowParameters(players: [], shiftPlayerId: 0, gameStarted: false)
        return parameters
    }()
}

extension GameFlowParameters {
    static let rowWinPatterns: [[TilePosition]] = [
        [
            TilePosition(row: 0, column: 0, depth: 0),
            TilePosition(row: 0, column: 0, depth: 1),
            TilePosition(row: 0, column: 0, depth: 2),
        ],
    ]
}
