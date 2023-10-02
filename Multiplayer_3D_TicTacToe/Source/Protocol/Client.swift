//
//  Client.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

protocol Client {
    var clientOutput: ClientOutput? { get set }
    
    func connectToServer(path: String, completion: @escaping (Bool) -> ())
    func disconnectToServer()
    func sendMessage(_ message: TransferMessage) async
    func handleMessageFromServer(_ message: TransferMessage) 
}
