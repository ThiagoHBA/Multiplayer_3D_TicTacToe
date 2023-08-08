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
    @State private var gameSessionCode: String = ""
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
                    title: "Iniciar jogo",
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
                    title: "Entrar",
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
                JoinGameSheet(
                    sessionCode: gameSessionCode,
                    connectButtonTapped: {
                        guard let serverURL = URL(
                            string: "ws://\(gameSessionCode):8080"
                        ) else {
                            errorAlert.errorMessage = "Não foi possível localizar a sessão. Tente novamente"
                            errorAlert.showAlert = true
                            return
                        }
                        client.connectToServer(url: serverURL)
                    }
                )
            }
        }
        
    }
}

