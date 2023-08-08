//
//  TransferMessage.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

enum MessageType: String, Codable{
    case connection = "#connection"
}

struct TransferMessage: Codable {
    var type: MessageType
    var data: Data
    
    func encodeToTransfer() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

extension TransferMessage {
    static var connectedMessage: TransferMessage {
        return TransferMessage(
            type: .connection,
            data: try! JSONEncoder().encode(ConnectedDTO(connected: true))
        )
    }
}
