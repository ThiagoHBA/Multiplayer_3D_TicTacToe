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
}
// MARK: - Client
extension SessionViewModel: ClientOutput {
    func gameDidStart() {
        DispatchQueue.main.async { [weak self] in
            self?.goToGameView = true
            self?.showJoinGameSheet = false
            if let playerIdentifier = self?.playerIdentifier {
                self?.serverStatus = "O jogo iniciou! Seus pontos são: \(playerIdentifier.tileStyle.rawValue)"
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
