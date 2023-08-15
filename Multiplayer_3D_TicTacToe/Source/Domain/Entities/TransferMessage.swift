//
//  TransferMessage.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

enum MessageType: Codable {
    case client(ClientMessages)
    case server(ServerMessages)
    
    enum ClientMessages: Codable {
        case gameFlow(ClientGameFlow)
        
        enum ClientGameFlow: String, Codable {
            case playerMove = "#playerMove"
        }
    }
    
    enum ServerMessages: Codable {
        case connection(ServerConnection)
        case gameFlow(ServerGameFlow)
        
        enum ServerConnection: String, Codable {
            case connected = "#connected"
        }
        
        enum ServerGameFlow: String, Codable {
            case gameStarted = "#gameStarted"
            case playerMove = "#playerMove"
            case changeShift = "#changeShift"
            case newState = "#newState"
        }
    }
}

// MARK: - Server Default Messages
struct TransferMessage: Codable {
    var type: MessageType
    var data: Data
    
    func encodeToTransfer() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

extension TransferMessage {
    static func getConnectedMessage(identifier: Player) -> TransferMessage {
        return TransferMessage(
            type: .server(.connection(.connected)),
            data: try! JSONEncoder().encode(
                ConnectedMessageDTO(
                    connected: true,
                    identifier: identifier
                )
            )
        )
    }
    
    static func getGameStartedMessage(value: Bool) -> TransferMessage {
        return TransferMessage(
            type: .server(.gameFlow(.gameStarted)),
            data: try! JSONEncoder().encode(BooleanMessageDTO(value: value))
        )
    }
    
    static func updateSessionParametersMessage(newState: SessionParameters) -> TransferMessage {
        return TransferMessage(
            type: .server(.gameFlow(.newState)),
            data: try! JSONEncoder().encode(newState)
        )
    }
    
    static func getEndPlayerMoveMessage(boardId: Int, tile: Tile) -> TransferMessage {
        return TransferMessage(
            type: .server(.gameFlow(.playerMove)),
            data: try! JSONEncoder().encode(
                PlayerMoveDTO(boardId: boardId, addedTile: tile)
            )
        )
    }
    
    static func getChangeShiftMessage(_ newShiftPlayerId: Int) -> TransferMessage {
        return TransferMessage(
            type: .server(.gameFlow(.changeShift)),
            data: try! JSONEncoder().encode(
                ChangeShiftDTO(shiftPlayerId: newShiftPlayerId)
            )
        )
    }
}

// MARK: - Client Default Messages

extension TransferMessage {
    static func getPlayerDidEndTheMoveMessage(on board: Int, _ tile: Tile) -> TransferMessage {
        TransferMessage(
            type: .client(.gameFlow(.playerMove)),
            data: try! JSONEncoder().encode(PlayerMoveDTO(boardId: board, addedTile: tile))
        )
    }
}
