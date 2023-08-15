//
//  Board.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation
import SwiftUI

enum BoardColor: Codable {
    case blue
    case red
    case green
}

struct Board: Identifiable, Codable {
    let id: Int
    let color: BoardColor
    var tiles: [Tile]
    
    static func generateBoards() -> [Board] {
        return [
            Board(id: 1, color: .red, tiles: []),
            Board(id: 2, color: .green, tiles: []),
            Board(id: 3, color: .blue, tiles: [])
        ]
    }
}
