//
//  Session.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 08/08/23.
//

import Foundation

protocol Session {
    var gameFlowParameters: GameFlowParameters { get }
    var chatParameters: ChatParameters { get }
    
    func addPlayerInSession() -> Player
    func selectStarterPlayer()
    func startGame()
    func addTileOnBoard(with id: Int, tile: Tile)
    func changePlayerShift()
    func playerSurrender(_ player: Player)
    func addChatMessage(_ message: ChatMessage)
}

