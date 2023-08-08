//
//  StartViewAssembler.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

final class StartViewAssembler {
    static func make() -> StartView {
        let server = try! TicTacToeServer()
        let client = TicTacToeClient.shared
        
        let startView = StartView(
            server: server,
            client: client
        )
        return startView
    }
}
