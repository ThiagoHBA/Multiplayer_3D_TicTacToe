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
    @State var server: any Server
    var client: any Client
    
    var body: some View {
        VStack {
            if sessionVM.parameters.gameStarted {
                Text(sessionVM.serverStatus)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding([.bottom], 62)
            }
            HStack(alignment: .top, spacing: 8) {
                ForEach(0..<3) { index in
                    TicTacToeBoard(
                        tiles: sessionVM.parameters.boards[index].tiles,
                        boardId: sessionVM.parameters.boards[index].id,
                        inputedStyle: sessionVM.playerIdentifier?.tileStyle ?? .cross,
                        backgroundColor: .red,
                        tileTapped: { position in
                            sessionVM.parameters.boards[index].tiles.append(
                                Tile(
                                    boardId: sessionVM.parameters.boards[index].id,
                                    style: .cross,
                                    position: position
                                )
                            )
                        }
                    )
                    .padding([.top], 120 * CGFloat(index))
                }
            }
        }
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
        .alert(isPresented: $errorAlert.showAlert) {
            Alert(
                title: Text("Erro!"),
                message: Text(errorAlert.errorMessage)
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
                        
                        Text(sessionVM.serverStatus)
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
        .navigationBarBackButtonHidden(true)
    }
}

