//
//  JoinGameSheet.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 08/08/23.
//

import SwiftUI

struct JoinGameSheet: View {
    @State var sessionCode: String
    var connectButtonTapped: (() -> ())?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Conecte-se a uma sessão")
                .font(.title)
                .bold()
                .foregroundColor(.black)
                .padding([.bottom], 18)
            
            TextField(
                "Hostname da sessão",
                text: $sessionCode
            )
            .padding(12)
            .frame(maxWidth: 300)
            .background(.white)
            .foregroundColor(.black)
            .cornerRadius(12)
            
            Button("Conectar") {
                connectButtonTapped?()
            }
            .bold()
            .padding()
        }
        .padding(12)
        .frame(width: 500, height: 500)
        .background(.blue.opacity(0.1))
        .cornerRadius(12)

    }
}
