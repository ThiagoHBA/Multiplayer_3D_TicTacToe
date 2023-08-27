//
//  TicTacToeClient.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

final class TicTacToeClient: NSObject, Client {
    private(set) var opened: Bool = false
    private(set) var webSocket: URLSessionWebSocketTask?
    static let shared = TicTacToeClient()
    lazy var session: URLSession = URLSession(
        configuration: .default,
        delegate: self,
        delegateQueue: nil
    )
    
    weak var clientOutput: ClientOutput?
    
    func connectToServer(url: URL) {
        if !opened { openWebSocket(url) }
        guard let webSocket = webSocket else { return }
        
        webSocket.receive(
            completionHandler: { [weak self] result in
                switch result {
                case .failure(_):
                    self?.opened = false
                    return
                case .success(let message):
                    self?.decodeServerMessage(message)
                }
                self?.connectToServer(url: url)
            }
        )
    }
    
    private func openWebSocket(_ baseURL: URL) {
        let request = URLRequest(url: baseURL)
        webSocket  = session.webSocketTask(with: request)
        opened = true
        webSocket?.resume()
    }
    
    private func decodeServerMessage(_ serverMessage: URLSessionWebSocketTask.Message) {
        switch serverMessage {
        case .data(let data):
            do {
                let message = try JSONDecoder().decode(TransferMessage.self, from: data)
                handleMessageFromServer(message)
            } catch {
                clientOutput?.errorWhileReceivingMessage(error)
            }
        default:
            break
        }
    }
    
    func disconnectToServer() {
        
    }
    
    func sendMessage(_ message: TransferMessage) {
        guard let webSocket = webSocket else { return }
        let encondedData = try! JSONEncoder().encode(message)
        webSocket.send(URLSessionWebSocketTask.Message.data(encondedData)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func handleMessageFromServer(_ message: TransferMessage) {
        switch message.type {
            case .client(_): break
            case .server(let serverMessage):
                switch serverMessage {
                    case .connection(_):
                        handleConnectionMessages(message)
                    case .gameFlow(let value):
                        handleGameFlowMessages(message, value)
                    case .chat(_):
                        handleChatMessages(message)
                }
            }
    }
}

// MARK: - Message Handlers
extension TicTacToeClient {
    func handleConnectionMessages(_ message: TransferMessage) {
        let dto = ConnectedMessageDTO.decodeFromMessage(message.data)
        if dto.connected {
            clientOutput?.didConnectInServer(dto.identifier)
        }
    }
    
    func handleGameFlowMessages(_ message: TransferMessage, _ messageValue: MessageType.ServerMessages.ServerGameFlow) {
        switch messageValue {
            case .gameStarted:
                let dto = BooleanMessageDTO.decodeFromMessage(message.data)
                if dto.value { clientOutput?.didGameStart() }
            case .newState:
                let dto = GameFlowParameters.decodeFromMessage(message.data)
                clientOutput?.didUpdateSessionParameters(dto)
            case .playerMove:
                let dto = PlayerMoveDTO.decodeFromMessage(message.data)
                clientOutput?.didFinishPlayerMove(on: dto.boardId, in: dto.addedTile)
            case .changeShift:
                let dto = ChangeShiftDTO.decodeFromMessage(message.data)
                clientOutput?.didChangeShift(dto.shiftPlayerId)
            case .gameEnd:
                let dto = GameEndDTO.decodeFromMessage(message.data)
                clientOutput?.didEndGame(
                    dto.winner,
                    surrender: dto.surrender,
                    winningTiles: dto.winningTiles
                )
        }
    }
    
    func handleChatMessages(_ message: TransferMessage) {
        let dto = ChatMessageDTO.decodeFromMessage(message.data)
        clientOutput?.didReceiveAChatMessage(dto.message)
    }
}

extension TicTacToeClient: URLSessionDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        opened = true
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.webSocket = nil
        self.opened = false
    }
}
