//
//  ServerStatusLabel.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 16/08/23.
//

import SwiftUI

struct ServerStatusLabel: View {
    var label: StatusLabel
    
    var body: some View {
        Text(label.text)
            .font(.largeTitle)
            .bold()
            .multilineTextAlignment(.center)
            .padding(32)
            .background(.ultraThinMaterial)
            .cornerRadius(26)
    }
}

struct ServerStatusLabel_Previews: PreviewProvider {
    static var previews: some View {
        ServerStatusLabel(
            label: StatusLabel(
                text: "É a vez do jogador 01",
                position: .center
            )
        )
    }
}
