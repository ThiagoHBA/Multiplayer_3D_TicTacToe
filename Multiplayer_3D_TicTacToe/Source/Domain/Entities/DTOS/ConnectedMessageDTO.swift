//
//  ConnectedMessageDTO.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 15/08/23.
//

import Foundation

struct ConnectedMessageDTO: Codable {
    let connected: Bool
    let identifier: Player
}
