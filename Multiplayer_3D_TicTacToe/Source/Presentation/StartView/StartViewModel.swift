//
//  StartViewModel.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 12/08/23.
//

import Foundation

final class StartViewModel: ObservableObject {
    @Published var connectedInServer: Bool = false
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

    }
}
