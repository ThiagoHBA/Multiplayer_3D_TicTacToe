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
                        break
                    case .gameFlow(let value):
                        handleGameFlowMessages(message, value)
                        break
                }
            }
    }
}

// MARK: - Message Handlers
extension TicTacToeClient {
    func handleConnectionMessages(_ message: TransferMessage) {
        guard let dto: ConnectedMessageDTO = decodeDTO(message.data) else { return }
        if dto.connected {
            clientOutput?.didConnectInServer(dto.identifier)
        }
    }
    
    func handleGameFlowMessages(_ message: TransferMessage, _ messageValue: MessageType.ServerMessages.ServerGameFlow) {
        switch messageValue {
            case .gameStarted:
                guard let dto: BooleanMessageDTO = decodeDTO(message.data) else { break }
                if dto.value { clientOutput?.didGameStart() }
            case .newState:
                guard let dto: SessionParameters = decodeDTO(message.data) else { break }
                clientOutput?.didUpdateSessionParameters(dto)
            case .playerMove:
                guard let dto: PlayerMoveDTO = decodeDTO(message.data) else { break }
                clientOutput?.didFinishPlayerMove(on: dto.boardId, in: dto.addedTile)
            case .changeShift:
                guard let dto: ChangeShiftDTO = decodeDTO(message.data) else { break }
                clientOutput?.didChangeShift(dto.shiftPlayerId)
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
            clientOutput?.errorWhileReceivingMessage(WebSocketError.unableToEncodeMessage)
        }
        return nil
    }
}
