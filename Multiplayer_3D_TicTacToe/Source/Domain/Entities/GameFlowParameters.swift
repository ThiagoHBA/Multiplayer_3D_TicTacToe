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
    var gameEnded: Bool
    var boards: [Board] = Board.generateBoards()
    var winner: Player? = nil
    
    static let initialState: GameFlowParameters = {
        let parameters = GameFlowParameters(players: [], shiftPlayerId: 0, gameStarted: false, gameEnded: false)
        return parameters
    }()
}

extension GameFlowParameters {
    static let rowWinPatterns: [[TilePosition]] = [
        [
            TilePosition(row: 0, column: 0, depth: 1),
            TilePosition(row: 0, column: 1, depth: 2),
            TilePosition(row: 0, column: 2, depth: 3),
        ],
        [
            TilePosition(row: 1, column: 0, depth: 1),
            TilePosition(row: 1, column: 1, depth: 2),
            TilePosition(row: 1, column: 2, depth: 3),
        ],
        [
            TilePosition(row: 2, column: 0, depth: 1),
            TilePosition(row: 2, column: 1, depth: 2),
            TilePosition(row: 2, column: 2, depth: 3),
        ],
    ]
    
    static let colWinPatters: [[TilePosition]] = [
        [
            TilePosition(row: 0, column: 0, depth: 1),
            TilePosition(row: 1, column: 0, depth: 2),
            TilePosition(row: 2, column: 0, depth: 3),
        ],
        [
            TilePosition(row: 0, column: 1, depth: 1),
            TilePosition(row: 1, column: 1, depth: 2),
            TilePosition(row: 2, column: 1, depth: 3),
        ],
        [
            TilePosition(row: 0, column: 2, depth: 1),
            TilePosition(row: 1, column: 2, depth: 2),
            TilePosition(row: 2, column: 2, depth: 3),
        ],
    ]

    static let vertexPatterns: [[TilePosition]] = {
        var list: [[TilePosition]] = []
        for i in 0..<3 {
            for j in 0..<3 {
                var pattern: [TilePosition] = []
                for k in 1...3 {
                    pattern.append(TilePosition(row: i, column: j, depth: k))
                }
                list.append(pattern)
            }
        }
        return list
    }()
}
