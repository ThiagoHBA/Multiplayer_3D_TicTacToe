//
//  TicTacToeClient.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

final class TicTacToeClient: Client {
    private(set) var opened: Bool = false
    private(set) var webSocket: URLSessionWebSocketTask?
    static let shared = TicTacToeClient()
    weak var output: ClientOutput?
    
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
                        break
                }
                self?.connectToServer(url: url)
            }
        )
    }
    
    private func openWebSocket(_ baseURL: URL) {
        let request = URLRequest(url: baseURL)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
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
                    output?.errorWhileReceivingMessage(error)
                }
            default:
                break
        }
    }
    
    func disconnectToServer() {
        
    }
    
    func sendMessage(_ message: TransferMessage) {
        
    }
    
    func handleMessageFromServer(_ message: TransferMessage) {
        switch message.type {
            case .connection(_):
                handleConnectionMessages(message)
                break
            case .gameFlow(let value):
                handleGameFlowMessages(message, value)
                break
        }
    }
}

// MARK: - Message Handlers
extension TicTacToeClient {
    func handleConnectionMessages(_ message: TransferMessage) {
        guard let dto: BooleanMessageDTO = decodeDTO(message.data) else { return }
        if dto.value { output?.didConnectInServer() }
    }
    
    func handleGameFlowMessages(_ message: TransferMessage, _ messageValue: MessageType.GameFlow) {
        switch messageValue {
            case .gameStarted:
                guard let dto: BooleanMessageDTO = decodeDTO(message.data) else { break }
                if dto.value { output?.gameDidStart() }
                break
        }
    }
}

// MARK: - Utilities
extension TicTacToeClient {
    private func decodeDTO<T: Decodable>(_ data: Data) -> T? {
        do {
            let data = try JSONDecoder().decode(T.self, from: data)
            return data
        } catch {
            output?.errorWhileReceivingMessage(WebSocketError.unableToEncodeMessage)
        }
        return nil
    }
}
