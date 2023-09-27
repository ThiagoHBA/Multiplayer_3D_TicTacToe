//
//  TicTacToeRPCServer.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 25/09/23.
//

import Foundation
import GRPC
import NIO

class TicTacToeRPCServer {
    var gameSession = TicTacToeProvider()
    
    func run() {
        // Create an event loop group for the server to run on.
        let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        defer {
          try! group.syncShutdownGracefully()
        }
        
        let configuration: GRPC.Server.Configuration = .default(
            target: .hostAndPort("localhost", 8080),
            eventLoopGroup: group,
            serviceProviders: [gameSession]
        )

        // Start the server and print its address once it has started.
        let server = GRPC.Server.start(configuration: configuration)

        server.map {
          $0.channel.localAddress
        }.whenSuccess { address in
          print("server started on port \(address!.port!)")
        }

        // Wait on the server's `onClose` future to stop the program from exiting.
        try? server.flatMap{ $0.onClose }.wait()
    }
}
