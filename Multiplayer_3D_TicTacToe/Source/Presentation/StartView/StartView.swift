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
    @State private var loading: Bool = false
    @State var gameSessionCode: String = ""
    
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
                
                if sessionVM.isHost {
                    Text("Compartilhe Seu código: \(gameSessionCode)")
                        .font(.title)
                        .bold()
                        .padding(16)
                    
                    Text("Aguardando jogador se conectar...")
                        .font(.title2)
                        .padding([.bottom], 12)
                    
                    if sessionVM.gameFlowParameters.players.count > 0 {
                        Text("Jogador conectado")
                            .font(.title3)
                            .padding([.bottom], 12)
                    }
                }
                
                if sessionVM.showStartGameButton {
                    LargeColoredButton(
                        title: "Iniciar Jogo",
                        color: .yellow,
                        onPressed: {
                            sessionVM.goToGameView = true
                            Task {
                                await sessionVM.manager.sendStartGameMessage(.init())
                            }
                        }
                    )
                }
                
                LargeColoredButton(
                    title: "Iniciar Sessão",
                    color: .red,
                    onPressed: {
                        gameSessionCode = "\(sessionVM.port)"
                        sessionVM.isHost = true
                    }
                )
                .opacity(sessionVM.isHost ? 0.5 : 1)
                .disabled(loading || sessionVM.isHost)
                
                LargeColoredButton(
                    title: "Entrar",
                    color: .blue,
                    onPressed: {
                        sessionVM.isHost = false
                        sessionVM.showJoinGameSheet = true
                    }
                )
                .opacity(sessionVM.isHost ? 0.5 : 1)
                .disabled(loading || sessionVM.isHost)
            }
            .overlay {
                if loading {
                    ProgressView()
                        .frame(width: 60, height: 60)
                }
            }
            .onAppear {
                sessionVM.manager.run(handler: { port in
                    self.sessionVM.port = port
                })
                sessionVM.manager.server.provider.output = sessionVM
            }
            .navigationDestination(isPresented: $sessionVM.goToGameView) {
                GameView()
            }
            .alert(isPresented: $errorAlert.showAlert) {
                Alert(
                    title: Text("Erro!"),
                    message: Text(errorAlert.errorMessage)
                )
            }
            .sheet(isPresented: $sessionVM.showJoinGameSheet) {
                JoinGameSheet(
                    sessionCode: $gameSessionCode,
                    connected: $sessionVM.isConnected,
                    connectButtonTapped: {
                        loading = true
                        self.sessionVM.manager.client.connectToService(
                            port:  Int(gameSessionCode)!,
                            completion: {
                                Task {
                                    await sessionVM.manager.sendConnectedMessage(port: sessionVM.port)
                                }
                            }
                        )
                        loading = false
                    }
                )
                .padding([.horizontal], 12)
            }
        }
    }
}

