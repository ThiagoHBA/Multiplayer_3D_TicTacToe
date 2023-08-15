//
//  WeakRefernce.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 14/08/23.
//

import Foundation

class Weak<T: AnyObject> {
  weak var value : T?
    
  init (_ value: T) {
    self.value = value
  }
}

extension Weak: ServerOutput where T: ServerOutput {
    func didStartServer(_ playerIdentifier: Player) {
        value?.didStartServer(playerIdentifier)
    }
    
    func didConnectAPlayer(_ player: Player) {
        value?.didConnectAPlayer(player)
    }
    
    func didStartGame() {
        value?.didStartGame()
    }
}

extension Weak: ConnectionOutput where T: ConnectionOutput {
    func didConnectInServer() {
        value?.didConnectInServer()
    }
    
    func gameDidStart(with players: [Player], identifier: Player) {
        value?.gameDidStart(with: players, identifier: identifier)
    }
}

extension Weak: ClientOutput where T: ClientOutput {
    func errorWhileReceivingMessage(_ error: Error) {
        value?.errorWhileReceivingMessage(error)
    }
}
