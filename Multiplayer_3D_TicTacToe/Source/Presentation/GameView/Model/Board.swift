//
//  Board.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation
import SwiftUI

struct Board: Identifiable {
    let id: Int
    let color: Color
    
    static func generateBoards() -> [Board] {
        return [
            Board(id: 1, color: .red),
            Board(id: 2, color: .green),
            Board(id: 3, color: .blue)
        ]
    }
}
