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
            case .string:
                print("String result: \(serverMessage)")
            case .data(let data):
                do {
                    let message = try JSONSerialization.jsonObject(with: data)
                    print(message)
                } catch {
                    print(error.localizedDescription)
                }
            @unknown default:
                break
        }
    }
    
    func disconnectToServer() {
        
    }
    
    func sendMessage(_ message: TransferMessage) {
        
    }    
}
