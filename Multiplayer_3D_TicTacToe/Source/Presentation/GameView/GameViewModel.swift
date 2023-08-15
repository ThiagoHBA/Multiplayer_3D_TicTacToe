//
//  GameViewModel.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

final class GameViewModel: ObservableObject {
    @Published var serverStatus = "Esperando jogador!"
    @Published var boardTiles: [Tile] = []
    @Published var boards: [Board] = Board.generateBoards()
}

extension GameViewModel: ServerOutput {
    func didStartGame() {
    }
    
    func didStartServer(_ playerIdentifier: Player) {
  
    }
    
    func didConnectAPlayer(_ player: Player) {
        DispatchQueue.main.async { [weak self] in
            self?.serverStatus = "Jogadores conectados, aguardando inicio!"
        }
    }
}
