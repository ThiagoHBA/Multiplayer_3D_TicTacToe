//
//  Multiplayer_3D_TicTacToeApp.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 04/08/23.
//

import SwiftUI

@main
struct Multiplayer_3D_TicTacToeApp: App {
    @StateObject var sessionViewModel = SessionViewModel()

    var body: some Scene {
        WindowGroup {
            StartViewAssembler.make()
                .environmentObject(sessionViewModel)
        }
    }
}
