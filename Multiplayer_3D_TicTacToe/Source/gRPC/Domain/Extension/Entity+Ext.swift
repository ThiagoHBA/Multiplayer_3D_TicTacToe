//
//  Entity+Ext.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 01/10/23.
//

import Foundation

extension Player {
    init(from grpcPlayer: Tictactoe_Player) {
        self.init(
            id: Int(grpcPlayer.id),
            name: grpcPlayer.name,
            tileStyle: TileStyle(from: grpcPlayer.tileStyle),
            tiles: grpcPlayer.tiles.compactMap { TilePosition(from: $0) }
        )
    }
    
    func toGRPCEntity() -> Tictactoe_Player {
        return Tictactoe_Player.with {
            $0.id = Int64(self.id)
            $0.name = self.name
            $0.tileStyle = self.tileStyle.toGRPCEntity()
            $0.tiles = self.tiles.compactMap { value in
                value.toGRPCEntity()
            }
        }
    }
}

extension TileStyle {
    init(from grpcTileStyle: Tictactoe_TileStyle) {
        self = grpcTileStyle.rawValue == 0 ? .cross : .circle
    }
    
    func toGRPCEntity() -> Tictactoe_TileStyle {
        return Tictactoe_TileStyle(rawValue: self == .cross ? 0 : 1)!
    }
}

extension TilePosition {
    init(from grpcTilePosition: Tictactoe_TilePosition) {
        self.init(
            row: Int(grpcTilePosition.row),
            column: Int(grpcTilePosition.column),
            depth: Int(grpcTilePosition.depth)
        )
    }
    
    func toGRPCEntity() -> Tictactoe_TilePosition {
        return Tictactoe_TilePosition.with {
            $0.column = Int64(self.column)
            $0.depth = Int64(self.depth)
            $0.row = Int64(self.row)
        }
    }
}

extension Tile {
    init(from grpcTile: Tictactoe_Tile) {
        self.init(
            boardId: Int(grpcTile.boardID),
            style: grpcTile.style.rawValue == 0 ? .cross : .circle,
            position: TilePosition(from: grpcTile.position)
        )
    }
    
    func toGRPCEntity() -> Tictactoe_Tile {
        if self.position != nil {
            return Tictactoe_Tile.with {
                $0.boardID = Int64(self.boardId)
                $0.style = self.style.toGRPCEntity()
                $0.position = self.position!.toGRPCEntity()
            }
        }
        return Tictactoe_Tile.with {
            $0.boardID = Int64(self.boardId)
            $0.style = self.style.toGRPCEntity()
        }
    }
}

extension Board {
    init(from grpcBoard: Tictactoe_Board) {
        self.init(
            id: Int(grpcBoard.id),
            color: BoardColor.fromInt(grpcBoard.color.rawValue),
            tiles: grpcBoard.tiles.compactMap { Tile(from: $0) }
        )
    }
    
    func toGRPCEntity() -> Tictactoe_Board {
        return Tictactoe_Board.with {
            $0.id = Int64(self.id)
            $0.color = Tictactoe_BoardColor(rawValue: self.color.toInt())!
            $0.tiles = self.tiles.compactMap { $0.toGRPCEntity() }
        }
    }
}

extension BoardColor {
    static func fromInt(_ intValue: Int) -> BoardColor {
        switch intValue {
            case 0:
                return BoardColor.blue
            case 1:
                return BoardColor.red
            case 2:
                return BoardColor.green
            default:
                return BoardColor.blue
        }
    }
    
    func toInt() -> Int {
        switch self {
            case .blue:
                return 0
            case .red:
                return 1
            case .green:
                return 2
        }
    }
}

extension GameFlowParameters {
    init(from grpcParameters: Tictactoe_GameflowParameters) {
        self.init(
            players: grpcParameters.players.compactMap { Player(from: $0)},
            shiftPlayerId: Int(grpcParameters.shiftPlayerID),
            gameStarted: grpcParameters.gameStarted,
            gameEnded: grpcParameters.gameEnded,
            boards: grpcParameters.boards.compactMap { Board(from: $0) },
            winner: grpcParameters.hasWinner ? Player(from: grpcParameters.winner) : nil
        )
    }
    
    func toGRPCEntity() -> Tictactoe_GameflowParameters {
        if self.winner != nil {
            return Tictactoe_GameflowParameters.with {
                $0.players = self.players.compactMap { $0.toGRPCEntity() }
                $0.shiftPlayerID = Int64(self.shiftPlayerId)
                $0.gameStarted = self.gameStarted
                $0.gameEnded = self.gameEnded
                $0.boards = self.boards.compactMap { $0.toGRPCEntity() }
                $0.winner = self.winner!.toGRPCEntity()
            }
        }
        return Tictactoe_GameflowParameters.with {
            $0.players = self.players.compactMap { $0.toGRPCEntity() }
            $0.shiftPlayerID = Int64(self.shiftPlayerId)
            $0.gameStarted = self.gameStarted
            $0.gameEnded = self.gameEnded
            $0.boards = self.boards.compactMap { $0.toGRPCEntity() }
        }
    }
}

extension ChatMessage {
    init(from grpcChatMessage: Tictactoe_ChatMessage) {
        self.sender = Player(from: grpcChatMessage.sender)
        self.message = grpcChatMessage.text
        self.sendedDate = Date.now
    }
    
    func toGRPCEntity() -> Tictactoe_ChatMessage {
        return Tictactoe_ChatMessage.with {
            $0.sender = self.sender.toGRPCEntity()
            $0.sendedDate = String()
            $0.text = self.message
        }
    }
}

extension ChatParameters {
    init(from grpcChatParameters: Tictactoe_ChatParameters) {
        self.messages = grpcChatParameters.messages.compactMap { ChatMessage(from: $0) }
    }
    
    func toGRPCEntity() -> Tictactoe_ChatParameters {
        return Tictactoe_ChatParameters.with {
            $0.messages = self.messages.compactMap { $0.toGRPCEntity() }
        }
    }
}
