//
//  TransferMessage.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

struct TransferMessage: Codable {
    var type: MessageType
    var data: Data
    
    func encodeToTransfer() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

// MARK: Server Default Messages
extension TransferMessage {
    static func getConnectedMessage(identifier: Player) -> TransferMessage {
        return TransferMessage(
            type: .server(.connection(.connected)),
            data: ConnectedMessageDTO(connected: true, identifier: identifier).encodeToTransfer()
        )
    }
    
    static func getGameStartedMessage(value: Bool) -> TransferMessage {
        return TransferMessage(
            type: .server(.gameFlow(.gameStarted)),
            data: BooleanMessageDTO(value: value).encodeToTransfer()
        )
    }
    
    static func updateSessionParametersMessage(newState: GameFlowParameters) -> TransferMessage {
        return TransferMessage(
            type: .server(.gameFlow(.newState)),
            data: newState.encodeToTransfer()
        )
    }
    
    static func getEndPlayerMoveMessage(boardId: Int, tile: Tile) -> TransferMessage {
        return TransferMessage(
            type: .server(.gameFlow(.playerMove)),
            data: PlayerMoveDTO(boardId: boardId, addedTile: tile).encodeToTransfer()
        )
    }
    
    static func getChangeShiftMessage(_ newShiftPlayerId: Int) -> TransferMessage {
        return TransferMessage(
            type: .server(.gameFlow(.changeShift)),
            data: ChangeShiftDTO(shiftPlayerId: newShiftPlayerId).encodeToTransfer()
        )
    }
    
    static func getGameEndMessage(_ winner: Player) -> TransferMessage {
        return TransferMessage(
            type: .server(.gameFlow(.gameEnd)),
            data: GameEndDTO(winner: winner).encodeToTransfer()
        )
    }
}

// MARK: - Client Default Messages

extension TransferMessage {
    static func getPlayerDidEndTheMoveMessage(on board: Int, _ tile: Tile) -> TransferMessage {
        return TransferMessage(
            type: .client(.gameFlow(.playerMove)),
            data: PlayerMoveDTO(boardId: board, addedTile: tile).encodeToTransfer()
        )
    }
    
    static func getPlayerSurrenderMessage(_ player: Player) -> TransferMessage {
        return TransferMessage(
            type: .client(.gameFlow(.playerSurrender)),
            data: PlayerSurrenderDTO(player: player).encodeToTransfer()
        )
    }
    
//    static func getSendChatMessage_Message() -> TransferMessage {
//        return TransferMessage(
//            type: .client(.chat(.sendChatMessage)),
//            data:
//        )
//    }
}
