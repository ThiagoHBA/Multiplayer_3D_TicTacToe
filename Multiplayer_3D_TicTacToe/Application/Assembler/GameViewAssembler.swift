//
//  GameViewAssembler.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 13/08/23.
//

import Foundation

final class GameViewAssembler {
    static func make(
        server: any Server = try! TicTacToeServer(),
        client: any Client = TicTacToeClient.shared
    ) -> GameView {
        let gameView = GameView(
            server: server,
            client: client
        )
        return gameView
    }
}
