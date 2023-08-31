//
//  JoinGameSheet.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 08/08/23.
//

import SwiftUI

struct JoinGameSheet: View {
    @State var sessionCode: String
    @Binding var connected: Bool
    var connectButtonTapped: (() -> ())?
    
    var body: some View {
        VStack(spacing: 16) {
            if !connected {
                Text("Conecte-se a uma sessão")
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                    .padding([.bottom], 18)
                
                #if os(macOS)
                    TextField(
                        "Hostname da sessão",
                        text: $sessionCode
                    )
                    .autocorrectionDisabled(true)
                    .padding(12)
                    .frame(maxWidth: 300)
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                #else
                    TextField(
                        "Hostname da sessão",
                        text: $sessionCode
                    )
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .padding(12)
                    .frame(maxWidth: 300)
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                #endif
                
                Button("Conectar") {
                    connectButtonTapped?()
                }
                .bold()
                .padding()
            } else {
                Text("Connectado a sessão: \(sessionCode)")
                    .font(.title)
                    .padding(12)
                    .multilineTextAlignment(.center)
                
                Text("Aguardando host iniciar o jogo...")
                    .font(.title2)
            }
        
        }
        .padding(12)
        .frame(width: 500, height: 500)
        .background(.blue.opacity(0.1))
        .cornerRadius(12)

    }
}
