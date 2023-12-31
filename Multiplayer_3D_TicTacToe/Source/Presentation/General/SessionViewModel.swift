//
//  SessionViewModel.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 14/08/23.
//

import Foundation

final class SessionViewModel: ObservableObject {
    @Published var gameFlowParameters: GameFlowParameters = GameFlowParameters.initialState
    @Published var chatParameters: ChatParameters = ChatParameters(messages: [])
    
    @Published var goToGameView: Bool = false
    @Published var showJoinGameSheet: Bool = false
    
    @Published var serverStatus: ServerMessages = .waitingPlayer
    @Published var winningTiles: [TilePosition] = []
    @Published var isHost = false
    @Published var playerIdentifier: Player? = nil
    @Published var isConnected = false
    
    var showConnectionSheet: Bool {
        return isHost && !gameFlowParameters.gameStarted
    }
    
    var isPlayerShift: Bool {
        gameFlowParameters.shiftPlayerId == playerIdentifier?.id
    }
}
// MARK: - Client
extension SessionViewModel: ClientOutput {
    func didEndGame(_ winner: Player, surrender: Bool, winningTiles: [TilePosition]) {
        DispatchQueue.main.async { [weak self] in
            if let playerIdentifier = self?.playerIdentifier {
                if playerIdentifier.id == winner.id {
                    self?.winningTiles = winningTiles
                    self?.serverStatus = .playerWinner
                    if surrender { self?.serverStatus = .playerWinningFromSurrender }
                } else {
                    self?.winningTiles = winningTiles
                    self?.serverStatus = .playerLoser
                    if surrender { self?.serverStatus = .playerSurrender }
                }
            }
        }
    }
    
    func didReceiveAChatMessage(_ message: ChatMessage) {
        DispatchQueue.main.async { [weak self] in
            self?.chatParameters.messages.append(message)
        }
    }
    
    func didFinishPlayerMove(on boardId: Int, in tile: Tile) { }
    
    func didChangeShift(_ newShiftPlayer: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let playerIdentifier = self.playerIdentifier {
                if newShiftPlayer == playerIdentifier.id {
                    self.serverStatus = .playersTurn
                } else {
                    self.serverStatus = .otherPlayerTurn
                }
            }
        }
    }
    
    func didGameStart() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.goToGameView = true
            self.showJoinGameSheet = false
            self.winningTiles = []
        }
    }
    
    func didUpdateSessionParameters(_ newState: GameFlowParameters) {
        DispatchQueue.main.async { [weak self] in
            self?.gameFlowParameters = newState
            guard let playerIndex = newState.players.firstIndex(where: {
                $0.id == self?.playerIdentifier?.id
            }) else { return }
            
            self?.playerIdentifier = newState.players[playerIndex]
        }
    }
    
    func errorWhileReceivingMessage(_ error: Error) { }
    
    func didConnectInServer(_ identifier: Player) {
        DispatchQueue.main.async { [weak self] in
            self?.isConnected = true
            self?.playerIdentifier = identifier
        }
    }
}
