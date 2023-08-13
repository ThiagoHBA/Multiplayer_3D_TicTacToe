//
//  StartViewModel.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 12/08/23.
//

import Foundation

final class StartViewModel: ObservableObject {
    @Published var connectedInServer: Bool = false
    @Published var goToGameView: Bool = false
    @Published var showJoinGameSheet: Bool = false
}

extension StartViewModel: ClientOutput {
    func errorWhileReceivingMessage(_ error: Error) {
        
    }
    
    func didConnectInServer() {
        DispatchQueue.main.async { [weak self] in
            self?.connectedInServer = true
        }
    }
    
    func gameDidStart(with players: [Player], identifier: Player) {
        DispatchQueue.main.async {
            self.showJoinGameSheet = false
            self.goToGameView = true
        }
    }
}
