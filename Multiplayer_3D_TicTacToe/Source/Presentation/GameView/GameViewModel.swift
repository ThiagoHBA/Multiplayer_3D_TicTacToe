//
//  GameViewModel.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

final class GameViewModel: ObservableObject {
    @Published var serverStatus = ""
    @Published var clientStatus = ""
}

extension GameViewModel: ServerOutput {
    func didConnectAPlayer() {
        clientStatus = "Connected a player"
    }
}
