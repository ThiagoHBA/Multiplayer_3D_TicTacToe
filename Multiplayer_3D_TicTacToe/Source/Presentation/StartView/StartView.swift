//
//  StartView.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import SwiftUI

struct StartView: View {
    @State private var errorAlert: AlertError = AlertError()
    @State private var showJoinGameSheet: Bool = false
    @State private var goToGameView: Bool = false
    var server: any Server
    var client: any Client
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "gamecontroller.fill")
                    .resizable()
                    .frame(width: 80, height: 60)
                    .padding(12)
                
                Text("3D TicTacToe")
                    .font(.largeTitle)
                    .bold()
                
                LargeColoredButton(
                    title: "Start Game",
                    color: .red,
                    onPressed: {
                        server.startServer { error in
                            if let error = error {
                                errorAlert = AlertError(
                                    showAlert: true,
                                    errorMessage: "Não foi possível inicializar o servidor: \(error.localizedDescription)"
                                )
                                return
                            }
                            goToGameView = true
                        }
                    }
                )
                
                LargeColoredButton(
                    title: "Join Game",
                    color: .blue,
                    onPressed: {
                        showJoinGameSheet = true
                    }
                )
            }
            .navigationDestination(isPresented: $goToGameView) {
                GameView(
                    server: server,
                    client: client
                )
            }
            .alert(isPresented: $errorAlert.showAlert) {
                Alert(
                    title: Text("Erro!"),
                    message: Text(errorAlert.errorMessage)
                )
            }
            .sheet(isPresented: $showJoinGameSheet) {
                TextField(
                    "Hostname da sessão",
                    text: .constant("Digite aqui")
                )
            }
        }
        
    }
}

