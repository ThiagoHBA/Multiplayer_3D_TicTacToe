//
//  StartViewAssembler.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

final class MainViewAssembler {
    static func make() -> MainView {
        let server = try! TicTacToeServer()
        let client = TicTacToeClient.shared
        
        let view = MainView(
            server: server,
            client: client
        )
        return view
    }
}
