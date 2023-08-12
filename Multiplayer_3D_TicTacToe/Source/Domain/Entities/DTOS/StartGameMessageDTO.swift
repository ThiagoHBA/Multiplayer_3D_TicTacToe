//
//  StartGameMessageDTO.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 12/08/23.
//

import Foundation

struct StartGameMessageDTO: Codable {
    var gameHasStarted: Bool
    var playerIdentifier: Player
    var allPlayers: [Player]
}
