//
//  StartView.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import SwiftUI

struct StartView: View {
    @StateObject var viewModel = StartViewModel()
    @State private var errorAlert: AlertError = AlertError()
    @State private var gameSessionCode: String = ""
    @State private var isHost = false
    @State var client: any Client
    var server: any Server
    
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
                        isHost = true
                        viewModel.goToGameView = true
                    }
                )
                
                LargeColoredButton(
                    title: "Entrar",
                    color: .blue,
                    onPressed: {
                        viewModel.showJoinGameSheet = true
                    }
                )
            }
            .onAppear{ client.output = viewModel }
            .navigationDestination(isPresented: $viewModel.goToGameView) {
                GameView(
                    server: server,
                    client: client,
                    isHost: isHost
                )
            }
            .alert(isPresented: $errorAlert.showAlert) {
                Alert(
                    title: Text("Erro!"),
                    message: Text(errorAlert.errorMessage)
                )
            }
            .sheet(isPresented: $viewModel.showJoinGameSheet) {
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

