//
//  TicTacToeSessionTests.swift
//  Multiplayer_3D_TicTacToeTests
//
//  Created by Thiago Henrique on 19/08/23.
//

import XCTest
@testable import Multiplayer_3D_TicTacToe

final class TicTacToeSessionTests: XCTestCase {
    func test_didHaveAWinner_if_detects_a_pattern_in_row_should_return_true() {
        let sut = makeSUT()
        let player1 = sut.addPlayerInSession()
        let _ = sut.addPlayerInSession()
        let player1Tiles: [Tile] = [
            Tile(boardId: 1, style: .cross, position: TilePosition(row: 0, column: 0, depth: 1)),
            Tile(boardId: 1, style: .cross, position: TilePosition(row: 1, column: 1, depth: 1)),
            Tile(boardId: 1, style: .cross, position: TilePosition(row: 2, column: 2, depth: 1)),
            Tile(boardId: 1, style: .cross, position: TilePosition(row: 0, column: 0, depth: 1)),
            Tile(boardId: 2, style: .cross, position: TilePosition(row: 0, column: 1, depth: 2)),
            Tile(boardId: 3, style: .cross, position: TilePosition(row: 0, column: 2, depth: 3))
        ]
        player1Tiles.forEach { sut.addTileToPlayer(player: player1, tile: $0) } 
        
        XCTAssertEqual(
            sut.didHaveAWinner(),
            [
                .init(row: 0, column: 0, depth: 1),
                .init(row: 0, column: 1, depth: 2),
                .init(row: 0, column: 2, depth: 3)
            ]
        )
    }
    
    func test_didHaveAWinner_if_detects_a_pattern_in_column_should_return_true() {
        let sut = makeSUT()
        let player1 = sut.addPlayerInSession()
        let _ = sut.addPlayerInSession()
        let player1Tiles: [Tile] = [
            Tile(boardId: 1, style: .cross, position: TilePosition(row: 0, column: 0, depth: 1)),
            Tile(boardId: 1, style: .cross, position: TilePosition(row: 1, column: 1, depth: 1)),
            Tile(boardId: 1, style: .cross, position: TilePosition(row: 2, column: 2, depth: 1)),
            Tile(boardId: 1, style: .cross, position: TilePosition(row: 1, column: 0, depth: 2)),
            Tile(boardId: 2, style: .cross, position: TilePosition(row: 0, column: 1, depth: 2)),
            Tile(boardId: 3, style: .cross, position: TilePosition(row: 2, column: 0, depth: 3))
        ]
        player1Tiles.forEach { sut.addTileToPlayer(player: player1, tile: $0) }
        
        XCTAssertEqual(
            sut.didHaveAWinner(),
            [
                .init(row: 0, column: 0, depth: 1),
                .init(row: 1, column: 0, depth: 2),
                .init(row: 2, column: 0, depth: 3)
            ]
        )
    }
    
    func test_didHaveAWinner_if_detects_a_pattern_in_vertex_should_return_true() {
        let sut = makeSUT()
        let player1 = sut.addPlayerInSession()
        let _ = sut.addPlayerInSession()
        let player1Tiles: [Tile] = [
            Tile(boardId: 1, style: .cross, position: TilePosition(row: 0, column: 0, depth: 1)),
            Tile(boardId: 1, style: .cross, position: TilePosition(row: 0, column: 1, depth: 1)),
            Tile(boardId: 2, style: .cross, position: TilePosition(row: 0, column: 0, depth: 2)),
            Tile(boardId: 3, style: .cross, position: TilePosition(row: 0, column: 0, depth: 3)),
            Tile(boardId: 1, style: .cross, position: TilePosition(row: 1, column: 1, depth: 2)),
            Tile(boardId: 3, style: .cross, position: TilePosition(row: 2, column: 0, depth: 3))
        ]
        player1Tiles.forEach { sut.addTileToPlayer(player: player1, tile: $0) }
        
        XCTAssertEqual(
            sut.didHaveAWinner(),
            [
                .init(row: 0, column: 0, depth: 1),
                .init(row: 0, column: 0, depth: 2),
                .init(row: 0, column: 0, depth: 3)
            ]
        )
    }
}

extension TicTacToeSessionTests {
    func makeSUT() -> TicTacToeSession {
        let sut = TicTacToeSession()
        return sut
    }
}
