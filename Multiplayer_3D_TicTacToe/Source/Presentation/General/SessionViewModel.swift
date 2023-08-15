//
//  SessionViewModel.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 14/08/23.
//

import Foundation

final class SessionViewModel: ObservableObject {
    @Published var parameters: SessionParameters = SessionParameters.initialState
    
    @Published var goToGameView: Bool = false
    @Published var showJoinGameSheet: Bool = false
    
    @Published var serverStatus = "Esperando jogador!"
    @Published var isHost = false
    @Published var playerIdentifier: Player? = nil
    @Published var isConnected = false
    
    var showConnectionSheet: Bool {
        return isHost && !parameters.gameStarted
    }
    var boards: [Board] {
        return parameters.boards
    }
    var isPlayerShift: Bool {
        return parameters.shiftPlayerId == playerIdentifier?.id
    }
}
// MARK: - Client
extension SessionViewModel: ClientOutput {
    func didFinishPlayerMove(on boardId: Int, in tile: Tile) { }
    
    func didChangeShift(_ newShiftPlayer: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let player = self.parameters.players.first(where: { $0.id == newShiftPlayer }) else { return }
            if let playerIdentifier = self.playerIdentifier {
                if self.isPlayerShift {
                    self.serverStatus = "Seu turno! Seus pontos são: \(playerIdentifier.tileStyle.rawValue)"
                } else {
                    self.serverStatus = "Vez de \(player.name)"
                }
            }
        }
    }
    
    func didGameStart() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.goToGameView = true
            self.showJoinGameSheet = false
            if let playerIdentifier = self.playerIdentifier {
                if self.isPlayerShift {
                    self.serverStatus = "Seu turno! Seus pontos são: \(playerIdentifier.tileStyle.rawValue)"
                } else {
                    self.serverStatus = "Vez de \(playerIdentifier.name)"
                }
            }
        }
    }
    
    func didUpdateSessionParameters(_ newState: SessionParameters) {
        DispatchQueue.main.async { [weak self] in
            self?.parameters = newState
        }
    }
    
    func errorWhileReceivingMessage(_ error: Error) { }
    
    func didConnectInServer(_ identifier: Player) {
        DispatchQueue.main.async { [weak self] in
            self?.isConnected = true
            self?.playerIdentifier = identifier
        }
    }
}
