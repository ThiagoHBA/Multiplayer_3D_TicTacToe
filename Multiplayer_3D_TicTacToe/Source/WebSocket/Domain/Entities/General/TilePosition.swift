//
//  TileTappedPosition.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import Foundation
import SwiftUI

public struct TilePosition: Equatable, Codable {
    public var row: Int
    public var column: Int
    public var depth: Int
}
