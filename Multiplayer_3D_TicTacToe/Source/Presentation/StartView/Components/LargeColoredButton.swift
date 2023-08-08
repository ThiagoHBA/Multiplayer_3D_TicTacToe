//
//  LargeColoredButton.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import SwiftUI

struct LargeColoredButton: View {
    let title: String
    let color: Color
    var onPressed: (() -> ())?
    
    var body: some View {
        Button {
            onPressed?()
        } label: {
            Text(title)
                .font(.title)
                .frame(width: 220, height: 50)
                .background(color)
                .foregroundColor(.black)
                .cornerRadius(24)
                .padding(12)
        }
        .buttonStyle(.plain)
    }
}
