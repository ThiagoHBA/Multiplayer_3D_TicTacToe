//
//  GameViewModel.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

final class GameViewModel: ObservableObject {
    @Published var clientStatus = ""
    @Published var playerIdentifier: Player?
    @Published var boardTiles: [Tile] = []
    @Published var players: [Player] = []
    @Published var gameStarted: Bool = false
}

extension GameViewModel: ServerOutput {
    func didStartServer(_ playerIdentifier: Player) {
        self.playerIdentifier = playerIdentifier
        self.players.append(playerIdentifier)
    }
    
    func didConnectAPlayer(_ player: Player) {
        clientStatus = "Connected a player: \(player.name)"
        self.players.append(player)
    }
}
