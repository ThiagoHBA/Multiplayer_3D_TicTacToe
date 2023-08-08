//
//  TileTappedPosition.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation
import SwiftUI

enum TileStyle: String {
    case cross = "X"
    case circle = "O"
}

struct TilePosition: Equatable {
    static func == (lhs: TilePosition, rhs: TilePosition) -> Bool {
        return lhs.boardId == rhs.boardId && lhs.position.row == rhs.position.row && lhs.position.column == rhs.position.column && lhs.style == rhs.style
    }
    
    var boardId: Int
    var style: TileStyle
    var position: (row: Int, column: Int)
}
