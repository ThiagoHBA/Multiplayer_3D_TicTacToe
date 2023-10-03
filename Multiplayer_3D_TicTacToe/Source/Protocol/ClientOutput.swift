//
//  ClientOutput.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 08/08/23.
//

import Foundation

protocol ClientOutput: AnyObject {
    func errorWhileReceivingMessage(_ error: Error)
    func didUpdateSessionParameters(_ newState: GameFlowParameters)
    func didUpdateChatParameters(_ newState: ChatParameters)
    func didConnectInServer(_ identifier: Player)
    func didGameStart()
    func didFinishPlayerMove(on boardId: Int, in tile: Tile)
    func didChangeShift(_ newShiftPlayer: Int)
    func didEndGame(_ winner: Player, surrender: Bool, winningTiles: [TilePosition])
    func didReceiveAChatMessage(_ message: ChatMessage)
    func didConnectAPlayer(with port: Int)
}
