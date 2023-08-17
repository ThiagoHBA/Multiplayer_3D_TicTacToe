//
//  ChatSheet.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 17/08/23.
//

import SwiftUI

struct ChatSheet: View {
    @State private(set) var messageText: String = ""
    let identifier: Player
    let messages: [ChatMessage]
    var sendMessageOnTap: ((String) -> ())?

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            if messages.isEmpty {
                Text("Nenhuma mensagem nesta conversa ainda!")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                
                Spacer()
            } else {
                ScrollView(showsIndicators: true) {
                    ForEach(messages.reversed()) { message in
                        HStack {
                            if message.sender.id == identifier.id {
                                Spacer()
                            }
                            
                            ChatMessageBaloon(message: message)
                                .padding([.vertical], 40)
                                .rotationEffect(.radians(.pi))
                                .scaleEffect(x: -1, y: 1, anchor: .center)
                            
                            if message.sender.id != identifier.id {
                                Spacer()
                            }
                        }
                    }
                    .padding([.horizontal], 20)

                }
                .rotationEffect(.radians(.pi))
                .scaleEffect(x: -1, y: 1, anchor: .center)
            }
            
            Divider()
                .padding()
            
            HStack {
                TextField(
                    "Write a message",
                    text: $messageText
                )
                .padding()
                .frame(height: 60, alignment: .bottom)
                .background(.gray.opacity(0.3))
                .cornerRadius(15)
                
                Button {
                    sendMessageOnTap?(messageText)
                    messageText = ""
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .frame(width: 46, height: 46)
                        .foregroundColor(.blue)
                        .padding([.horizontal], 8)
                }
            }
        }
        .padding()
    }
}

struct ChatSheet_Previews: PreviewProvider {
    static var previews: some View {
        ChatSheet(
            identifier: Player(id: 1, name: "Player 01", tileStyle: .cross, tiles: []),
            messages: []
        )
    }
}
