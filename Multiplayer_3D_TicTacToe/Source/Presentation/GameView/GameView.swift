//
//  GameView.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 04/08/23.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var vm = GameViewModel()
    var server: any Server
    var client: any Client
    
    init(server: any Server, client: any Client) {
        self.server = server
        self.client = client
        
        self.server.output = vm
    }
    
    var body: some View {
        VStack {
            Text("Server Status: \(vm.serverStatus)")
            Text("Client Status: \(vm.clientStatus)")
            
            HStack {
                Button("Start Server") {
                    server.startServer { error in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                            vm.serverStatus = "Error connecting in server"
                        } else {
                            vm.serverStatus = "Connect successfuly in server"
                        }
                    }
                }
                
                Button("Connect Server") {
                    client.connectToServer(
                        url: URL(
                            string: "ws://\(ProcessInfo().hostName):8080"
                        )!
                    )
                }
            }
        }
    }
}

