//
//  GameViewModel.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

final class GameViewModel: ObservableObject {
    @Published var serverStatus = "Esperando jogador!"
    @Published var playerIdentifier: Player?
    @Published var boardTiles: [Tile] = []
    @Published var players: [Player] = []
    @Published var gameStarted: Bool = false
}

extension GameViewModel: ServerOutput {
    func didStartGame() {
        DispatchQueue.main.async { [weak self] in
            self?.gameStarted = true
        }
    }
    
    func didStartServer(_ playerIdentifier: Player) {
        self.playerIdentifier = playerIdentifier
        self.players.append(playerIdentifier)
    }
    
    func didConnectAPlayer(_ player: Player) {
        DispatchQueue.main.async { [weak self] in
            self?.serverStatus = "Jogadores conectados, aguardando inicio!"
            self?.players.append(player)
        }
    }
}
