//
//  Client.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

protocol Client {
    var connectionOutput: [ConnectionOutput]? { get set }
    var clientOutput: [ClientOutput]? { get set }
    
    func connectToServer(url: URL)
    func disconnectToServer()
    func sendMessage(_ message: TransferMessage)
    func handleMessageFromServer(_ message: TransferMessage) 
}
