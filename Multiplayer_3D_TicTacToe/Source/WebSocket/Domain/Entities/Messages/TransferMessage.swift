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
    
    static func getEndPlayerMoveMessage(player: Player, boardId: Int, tile: Tile) -> TransferMessage {
        return TransferMessage(
            type: .server(.gameFlow(.playerMove)),
            data: PlayerMoveDTO(
                player: player,
                boardId: boardId,
                addedTile: tile
            ).encodeToTransfer()
        )
    }
    
    static func getChangeShiftMessage(_ newShiftPlayerId: Int) -> TransferMessage {
        return TransferMessage(
            type: .server(.gameFlow(.changeShift)),
            data: ChangeShiftDTO(shiftPlayerId: newShiftPlayerId).encodeToTransfer()
        )
    }
    
    static func getGameEndMessage(
        winner: Player,
        surrender: Bool = false,
        winningTiles: [TilePosition]
    ) -> TransferMessage {
        return TransferMessage(
            type: .server(.gameFlow(.gameEnd)),
            data: GameEndDTO(
                winner: winner,
                surrender: surrender,
                winningTiles: winningTiles
            )
            .encodeToTransfer()
        )
    }
    
    static func getReceiveChatMessage_Message(_ message: ChatMessage) -> TransferMessage {
        return TransferMessage(
            type: .server(.chat(.receiveChatMessage)),
            data: ChatMessageDTO(message: message).encodeToTransfer()
        )
    }
}

// MARK: - Client Default Messages

extension TransferMessage {
    static func getConnectionMessage() -> TransferMessage {
        return TransferMessage(
            type: .client(.connection(.clientConnection)),
            data: Data()
        )
    }
    static func getPlayerDidEndTheMoveMessage(from player: Player, on board: Int, _ tile: Tile) -> TransferMessage {
        return TransferMessage(
            type: .client(.gameFlow(.playerMove)),
            data: PlayerMoveDTO(
                player: player,
                boardId: board,
                addedTile: tile
            ).encodeToTransfer()
        )
    }
    
    static func getPlayerSurrenderMessage(_ player: Player) -> TransferMessage {
        return TransferMessage(
            type: .client(.gameFlow(.playerSurrender)),
            data: PlayerSurrenderDTO(player: player).encodeToTransfer()
        )
    }
    
    static func getSendChatMessage_Message(_ messageToSend: ChatMessage) -> TransferMessage {
        return TransferMessage(
            type: .client(.chat(.sendChatMessage)),
            data: ChatMessageDTO(message: messageToSend).encodeToTransfer()
        )
    }
    
    static func getPlayAgainMessage() -> TransferMessage {
        return TransferMessage(
            type: .client(.gameFlow(.playAgain)),
            data: BooleanMessageDTO(value: true).encodeToTransfer()
        )
    }
}
