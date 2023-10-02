//
//  RPCProviderOutput.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 30/09/23.
//

import Foundation

protocol RPCProviderOutput {
    func didStablishConnection(identifier: Player)
    func didConnectAPlayer(with port: Int)
    func didStartGame(starterPlayerId: Int)
}
