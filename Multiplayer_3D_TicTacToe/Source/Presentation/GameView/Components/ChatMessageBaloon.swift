//
//  ChatMessageBaloon.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 17/08/23.
//

import SwiftUI

struct ChatMessageBaloon: View {
    var message: ChatMessage
    
    var body: some View {
        HStack(alignment: .top) {
            
            Text(message.message)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding([.trailing], 16)
            
            VStack(alignment: .trailing) {
                Image(
                    systemName: message.sender.tileStyle == .circle ?
                        "circle.circle.fill" :
                        "x.circle.fill"
                )
                    .resizable()
                    .frame(width: 42, height: 42)
                
                Text(
                    message.sendedDate.formatted(
                        date: .omitted,
                        time: .shortened
                    )
                )
                .font(.caption)
            }
            .padding(4)
        }
        .frame(alignment: .bottom)
        .padding(18)
        .background(.blue)
        .cornerRadius(16)
    }
}

struct ChatMessageBaloon_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageBaloon(
            message: ChatMessage(
                sender: Player(id: 0, name: "Player 01", tileStyle: .circle, tiles: []),
                message: "Message teste",
                sendedDate: Date.now
            )
        )
    }
}
