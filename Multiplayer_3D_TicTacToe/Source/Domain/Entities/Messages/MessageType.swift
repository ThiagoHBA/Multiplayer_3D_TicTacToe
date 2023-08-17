//
//  MessageType.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 17/08/23.
//

import Foundation

enum MessageType: Codable {
    case client(ClientMessages)
    case server(ServerMessages)
    
    enum ClientMessages: Codable {
        case gameFlow(ClientGameFlow)
        case chat(ClientChat)
        
        enum ClientGameFlow: String, Codable {
            case playerMove = "#playerMove"
            case playerSurrender = "#playerSurrender"
        }
        
        enum ClientChat: String, Codable {
            case receiveChatMessage = "#receiveChatMessage"
            case sendChatMessage = "#sendChatMessage"
        }
    }
    
    enum ServerMessages: Codable {
        case connection(ServerConnection)
        case gameFlow(ServerGameFlow)
        case chat(ServerChat)
        
        enum ServerConnection: String, Codable {
            case connected = "#connected"
        }
        
        enum ServerGameFlow: String, Codable {
            case gameStarted = "#gameStarted"
            case playerMove = "#playerMove"
            case changeShift = "#changeShift"
            case newState = "#newState"
            case gameEnd = "#gameEnd"
        }
        
        enum ServerChat: String, Codable {
            case receiveChatMessage = "#receiveChatMessage"
        }
    }
}
