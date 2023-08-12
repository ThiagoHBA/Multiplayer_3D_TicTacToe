//
//  StartView.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import SwiftUI

struct StartView: View {
    @ObservedObject private var viewModel = StartViewModel()
    @State private var errorAlert: AlertError = AlertError()
    @State private var showJoinGameSheet: Bool = false
    @State private var goToGameView: Bool = false
    @State private var gameSessionCode: String = ""
    var server: any Server
    var client: any Client
    
    init(server: any Server, client: any Client) {
        self.server = server
        self.client = client
        self.client.output = viewModel
    }
    
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
                    title: "Iniciar Sessão",
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
                    connected: $viewModel.connectedInServer,
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

