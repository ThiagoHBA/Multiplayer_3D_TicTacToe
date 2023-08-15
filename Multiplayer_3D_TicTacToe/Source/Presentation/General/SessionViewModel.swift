//
//  SessionViewModel.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 14/08/23.
//

import Foundation

final class SessionViewModel: ObservableObject {
    @Published var isHost = false
    @Published var playerIdentifier: Player? = nil
    @Published var players: [Player] = []
    @Published var gameStarted = false
    @Published var isConnected = false
    var showConnectionSheet: Bool {
        return isHost && !gameStarted
    }
}

extension SessionViewModel: ServerOutput {
    func didStartServer(_ playerIdentifier: Player) {
        DispatchQueue.main.async { [weak self] in
            self?.isHost = true
            self?.isConnected = true
            self?.playerIdentifier = playerIdentifier
            self?.players.append(playerIdentifier)
        }
    }
    
    func didConnectAPlayer(_ player: Player) {
        DispatchQueue.main.async { [weak self] in
            self?.players.append(player)
        }
    }
    
    func didStartGame() {
        DispatchQueue.main.async { [weak self] in
            self?.gameStarted = true
        }
    }
}

// MARK: - Client
extension SessionViewModel: ConnectionOutput {
    func didConnectInServer() {
        DispatchQueue.main.async { [weak self] in
            self?.isConnected = true
        }
    }
    
    func gameDidStart(with players: [Player], identifier: Player) {
        DispatchQueue.main.async { [weak self] in
            self?.gameStarted = true
            self?.playerIdentifier = identifier
            self?.players = players
        }
    }
}

extension SessionViewModel: ClientOutput {
    func errorWhileReceivingMessage(_ error: Error) {
        
    }
}
