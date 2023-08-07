//
//  Server.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 04/08/23.
//

import Foundation

protocol Server {
    associatedtype Connection
    var connectedClients: [Connection] { get set }
    var output: ServerOutput? { get set }
    
    func sendMessageToClient(
        message: TransferMessage,
        client: Connection,
        completion: @escaping (WebSocketError?) -> Void
    )
    func startServer(completion: @escaping (WebSocketError?) -> Void )
    func sendMessageToAllClients(_ message: Data)}