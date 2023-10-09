//
//  ServerMessages.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 16/08/23.
//

import Foundation

enum ServerMessages: String {
    case waitingPlayer = "Esperando jogador!"
    case playersTurn = "Seu turno!"
    case otherPlayerTurn = "Turno do outro jogador!"
    case playerWinner = "Você venceu!"
    case playerLoser = "Você perdeu!"
    case playerWinningFromSurrender = "O outro jogador desistiu, você venceu!"
    case playerSurrender = "Você desistiu"
    case tied = "Empatou!"
}
