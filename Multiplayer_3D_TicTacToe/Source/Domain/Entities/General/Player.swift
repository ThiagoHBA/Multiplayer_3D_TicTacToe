//
//  Player.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 08/08/23.
//

import Foundation

struct Player: Codable {
    var id: Int
    var name: String
    var tileStyle: TileStyle
    var tiles: [TilePosition]
}
