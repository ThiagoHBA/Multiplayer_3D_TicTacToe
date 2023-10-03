//
//  TicTacToeRPCClient.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 25/09/23.
//

import Foundation
import GRPC
import NIO

class TicTacToeRPCClient {
    var service: Tictactoe_TicTacToeNIOClient!
    private var group: MultiThreadedEventLoopGroup!
    
    init(completion: @escaping () -> ()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
            completion()
        }
    }
    
    deinit {
        do {
            try group.syncShutdownGracefully()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func connectToService(port: Int, completion: @escaping () -> ()) {
        let target = ConnectionTarget.hostAndPort("localhost", port)
        let configuration: ClientConnection.Configuration = .default(target: target, eventLoopGroup: group)
        let connection = ClientConnection(configuration: configuration)
        self.service = Tictactoe_TicTacToeNIOClient(channel: connection)
        completion()
    }
}
