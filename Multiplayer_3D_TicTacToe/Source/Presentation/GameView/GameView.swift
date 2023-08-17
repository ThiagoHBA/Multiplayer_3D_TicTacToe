//
//  GameView.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 04/08/23.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var sessionVM: SessionViewModel
    @State private var errorAlert: AlertError = AlertError()
    @State private var confirmationAlert: ConfirmationAlert = ConfirmationAlert()
    @State var server: any Server
    var client: any Client
    
    var body: some View {
        VStack {
            if sessionVM.parameters.gameStarted {
                ServerStatusLabel(
                    label: StatusLabel(
                        text: sessionVM.serverStatus.rawValue,
                        position: .top
                    )
                )
                .padding([.bottom], 120)
            }
            HStack(alignment: .top, spacing: 8) {
                ForEach($sessionVM.parameters.boards) { board in
                    TicTacToeBoard(
                        board: board,
                        inputedStyle: sessionVM.playerIdentifier?.tileStyle ?? .cross,
                        tileTapped: { tile in
                            if !sessionVM.isPlayerShift { return }

                            confirmationAlert = ConfirmationAlert(
                                showAlert: true,
                                description: "Você confirma a colocação do ponto?",
                                action: {
                                    client.sendMessage(
                                        TransferMessage.getPlayerDidEndTheMoveMessage(
                                            on: tile.boardId,
                                            tile
                                        )
                                    )
                                }
                            )
                        }
                    )
                }
                .opacity(sessionVM.isPlayerShift || sessionVM.parameters.winner != nil ? 1 : 0.2)
                .disabled(!sessionVM.parameters.gameStarted || sessionVM.parameters.winner != nil)
            }
        }
        .padding([.horizontal], 64)
        .onAppear {
            if sessionVM.isHost {
                server.startServer { error in
                    if let error = error {
                        errorAlert = AlertError(
                            showAlert: true,
                            errorMessage: "Não foi possível inicializar o servidor: \(error.localizedDescription)"
                        )
                        return
                    }
                }
                client.connectToServer(url: server.serverURL)
            }
        }
        .alert(isPresented: $confirmationAlert.showAlert) {
            Alert(
                title: Text("Ação"),
                message: Text(confirmationAlert.description),
                primaryButton: .default(Text("Confirmar"), action: confirmationAlert.action),
                secondaryButton: .cancel()
            )
        }
        .opacity(sessionVM.showConnectionSheet ? 0.05 : 1)
        .overlay {
            if sessionVM.showConnectionSheet {
                VStack {
                    ProgressView()
                        .padding(16)
                    
                    VStack(spacing: 24) {
                        Text("Código da sessão: \(ProcessInfo().hostName)")
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .bold()
                        
                        Text(sessionVM.serverStatus.rawValue)
                            .multilineTextAlignment(.center)
                            .font(.title2)
                    }
                    .padding(18)
                    
                    if sessionVM.parameters.players.count >= 2 {
                        Button {
                            server.startGame()
                        } label: {
                            Text("Iniciar Jogo")
                                .bold()
                        }
                    }
                }
            }
        }
        .toolbar {
            if sessionVM.parameters.gameStarted {
                Button("Chat") {
                    
                }
                
                Button("Desistir") {
                    guard let player = sessionVM.playerIdentifier else { return }
                    client.sendMessage(TransferMessage.getPlayerSurrenderMessage(player))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

