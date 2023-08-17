//
//  ChatParameters.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 17/08/23.
//

import Foundation

struct ChatMessage: Codable {
    let sender: Player
    let message: String
    let sendedDate: Date
}

struct ChatParameters: Codable {
    var messages: [ChatMessage]
}
