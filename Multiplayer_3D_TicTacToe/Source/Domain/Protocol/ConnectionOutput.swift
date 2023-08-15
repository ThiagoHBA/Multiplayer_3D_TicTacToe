//
//  ConnectionOutput.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 14/08/23.
//

import Foundation

protocol ConnectionOutput: AnyObject {
    func didConnectInServer()
    func gameDidStart(with players: [Player], identifier: Player)
}
