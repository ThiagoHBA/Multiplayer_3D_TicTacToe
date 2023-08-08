//
//  TyleStyle.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 08/08/23.
//

import Foundation

enum TileStyle: String {
    case cross = "X"
    case circle = "O"
    
    static func randomStyle() -> TileStyle {
        let value = Int.random(in: 0...1) == 0 ? TileStyle.cross : TileStyle.circle
        return value
    }
}
