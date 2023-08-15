//
//  StartViewModel.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 12/08/23.
//

import Foundation

final class StartViewModel: ObservableObject {
    @Published var goToGameView: Bool = false
    @Published var showJoinGameSheet: Bool = false
    @Published var gameSessionCode: String = ""
}

extension StartViewModel: ConnectionOutput {
    func didConnectInServer() { }
    
    func gameDidStart(with players: [Player], identifier: Player) {
        DispatchQueue.main.async {
            self.showJoinGameSheet = false
            self.goToGameView = true
        }
    }
}
