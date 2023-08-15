//
//  GameView.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 04/08/23.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var sessionVM: SessionViewModel
    @StateObject var vm = GameViewModel()
    @State private var errorAlert: AlertError = AlertError()
    @State var server: any Server
    var client: any Client
    
    var body: some View {
        VStack {
            if sessionVM.gameStarted {
                Text(sessionVM.serverStatus)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding([.bottom], 62)
            }
            HStack(alignment: .top, spacing: 8) {
                ForEach(0..<3) { index in
                    TicTacToeBoard(
                        tiles: vm.boardTiles,
                        boardId: vm.boards[index].id,
                        inputedStyle: sessionVM.playerIdentifier?.tileStyle ?? .cross,
                        backgroundColor: .red,
                        tileTapped: { position in
                            vm.boardTiles.append(
                                Tile(
                                    boardId: vm.boards[index].id,
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
                server.output?.append(Weak(sessionVM))
                server.startServer { error in
                    if let error = error {
                        errorAlert = AlertError(
                            showAlert: true,
                            errorMessage: "Não foi possível inicializar o servidor: \(error.localizedDescription)"
                        )
                        return
                    }
                }
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
                    
                    if sessionVM.players.count >= 2 {
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

