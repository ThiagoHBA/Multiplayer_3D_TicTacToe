//
//  GameView.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 04/08/23.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var vm = GameViewModel()
    var boards: [Board] = Board.generateBoards()
    var server: any Server
    var client: any Client
    
    init(server: any Server, client: any Client) {
        self.server = server
        self.client = client
        self.server.output = vm
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ForEach(0..<3) { index in
                TicTacToeBoard(
                    tiles: vm.boardTiles,
                    boardId: boards[index].id,
                    inputedStyle: .cross,
                    backgroundColor: .red,
                    tileTapped: { position in
                        vm.boardTiles.append(
                            Tile(
                                boardId: boards[index].id,
                                style: .cross,
                                position: position
                            )
                        )
                    }
                )
                .padding([.top], 120 * CGFloat(index))
            }
        }
        .opacity(vm.gameStarted ? 1 : 0.05)
        .overlay {
            if !vm.gameStarted {
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

