//
//  GameViewModel.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation

final class GameViewModel: ObservableObject {
    @Published var boardTiles: [Tile] = []
    @Published var boards: [Board] = Board.generateBoards()
}
