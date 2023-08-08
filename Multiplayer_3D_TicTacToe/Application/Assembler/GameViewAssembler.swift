//
//  GameViewAssembler.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 04/08/23.
//

import Foundation
import SwiftUI

final class GameViewAssembler {
    static func make() -> GameView {
        let server = try! TicTacToeServer()
        let client = TicTacToeClient.shared
        let gameView = GameView(server: server, client: client)
        
        return gameView
    }
}
