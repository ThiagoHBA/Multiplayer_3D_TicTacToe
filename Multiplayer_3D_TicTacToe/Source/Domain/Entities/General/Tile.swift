//
//  Tile.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 08/08/23.
//

import Foundation

struct Tile: Equatable, Codable {
    var boardId: Int
    var style: TileStyle
    var position: TilePosition?
}
