//
//  ClientOutput.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 08/08/23.
//

import Foundation

protocol ClientOutput: AnyObject {
    func errorWhileReceivingMessage(_ error: Error)
    func didUpdateSessionParameters(_ newState: SessionParameters)
    func didConnectInServer(_ identifier: Player)
    func gameDidStart()
}
