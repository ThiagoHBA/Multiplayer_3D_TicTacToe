//
//  ServerOutput.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 04/08/23.
//

import Foundation

protocol ServerOutput: AnyObject {
    func didStartServer(_ playerIdentifier: Player)
    func didConnectAPlayer(_ player: Player)
}

