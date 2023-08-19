//
//  StartView.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var sessionVM: SessionViewModel
    @State private var errorAlert: AlertError = AlertError()
    @State var gameSessionCode: String = ""
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
                        sessionVM.isHost = true
                        sessionVM.goToGameView = true
                    }
                )
                
                LargeColoredButton(
                    title: "Entrar",
                    color: .blue,
                    onPressed: {
                        sessionVM.isHost = false
                        sessionVM.showJoinGameSheet = true
                    }
                )
            }
            .onAppear{
                client.clientOutput = sessionVM
            }
            .navigationDestination(isPresented: $sessionVM.goToGameView) {
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
            .sheet(isPresented: $sessionVM.showJoinGameSheet) {
                JoinGameSheet(
                    sessionCode: gameSessionCode,
                    connected: $sessionVM.isConnected,
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
                .padding([.horizontal], 12)
            }
        }
    }
}

