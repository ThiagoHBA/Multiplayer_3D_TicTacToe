//
//  MainView.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 13/08/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    var server: any Server
    var client: any Client
    
    var body: some View {
        ZStack {
            switch mainViewModel.currentView {
                case .startView:
                    StartView(server: server, client: client)
                case .gameView:
                    GameView(server: server, client: client)
            }
        }
    }
}
