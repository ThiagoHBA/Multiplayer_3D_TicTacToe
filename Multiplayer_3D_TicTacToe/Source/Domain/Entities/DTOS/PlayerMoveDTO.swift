//
//  PlayerMoveDTO.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 15/08/23.
//

import Foundation

struct PlayerMoveDTO: Codable {
    var boardId: Int
    var addedTile: Tile
}
