//
//  TicTacToeSessionTests.swift
//  Multiplayer_3D_TicTacToeTests
//
//  Created by Thiago Henrique on 19/08/23.
//

import XCTest
@testable import Multiplayer_3D_TicTacToe

final class TicTacToeSessionTests: XCTestCase {
    func test_didHaveAWinner_if_detects_a_winner_should_return_true() {
        let sut = makeSUT()
        let _ = sut.addPlayerInSession()
        let _ = sut.addPlayerInSession()
    }
    
}

extension TicTacToeSessionTests {
    func makeSUT() -> TicTacToeSession {
        let sut = TicTacToeSession()
        return sut
    }
}
