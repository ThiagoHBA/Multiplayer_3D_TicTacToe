//
//  Client.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

protocol Client {
    func connectToServer(url: URL)
    func disconnectToServer()
    func sendMessage(_ message: TransferMessage)
}
