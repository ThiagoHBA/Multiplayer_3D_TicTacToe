//
//  Session.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 08/08/23.
//

import Foundation

protocol Session {
    var players: [Player] { get set }
    
    func createPlayer() -> Player
}

