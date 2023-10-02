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
            StartView()
                .environmentObject(sessionViewModel)
//            StartViewAssembler.make()
//            StartViewAssembler.makeGRPC()
//                            .environmentObject(sessionViewModel)
            /*EmptyView*/
        }
    }
}
