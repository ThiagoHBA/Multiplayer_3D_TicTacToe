//
//  TransferMessage.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

enum MessageType: Codable {
    case connection(Connection)
    case gameFlow(GameFlow)
    
    enum Connection: String, Codable {
        case connected = "#connected"
    }
    
    enum GameFlow: String, Codable {
        case gameStarted = "#gameStarted"
    }
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
            type: .connection(.connected),
            data: try! JSONEncoder().encode(BooleanMessageDTO(value: true))
        )
    }
    
    static func getGameStartedMessage(identifier: Player, allPlayers: [Player]) -> TransferMessage {
        return TransferMessage(
            type: .gameFlow(.gameStarted),
            data: try! JSONEncoder().encode(
                StartGameMessageDTO(
                    gameHasStarted: true,
                    playerIdentifier: identifier,
                    allPlayers: allPlayers
                )
            )
        )
    }
}
