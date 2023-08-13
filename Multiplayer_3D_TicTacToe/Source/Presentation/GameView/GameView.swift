//
//  GameView.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 04/08/23.
//

import SwiftUI

struct GameView: View {
    @StateObject var vm = GameViewModel()
    @State private var errorAlert: AlertError = AlertError()
    @State var server: any Server
    var client: any Client
    var isHost: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ForEach(0..<3) { index in
                TicTacToeBoard(
                    tiles: vm.boardTiles,
                    boardId: vm.boards[index].id,
                    inputedStyle: .cross,
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
        .onAppear {
            if isHost {
                server.output = vm
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
        .opacity(isHost && !vm.gameStarted ? 0.05 : 1)
        .overlay {
            if isHost && !vm.gameStarted {
                VStack {
                    ProgressView()
                        .padding(16)
                    
                    VStack(spacing: 24) {
                        Text("Código da sessão: \(ProcessInfo().hostName)")
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .bold()
                        
                        Text(vm.serverStatus)
                            .multilineTextAlignment(.center)
                            .font(.title2)
                    }
                    .padding(18)
                    
                    if vm.players.count >= 2 {
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

