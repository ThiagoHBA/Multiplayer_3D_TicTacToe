//
//  DTOProtocol.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 17/08/23.
//

import Foundation

protocol DTO: Codable {
    func encodeToTransfer() -> Data
}

extension DTO {
    func encodeToTransfer() -> Data {
        return try! JSONEncoder().encode(self)
    }
    
    static func decodeFromMessage(_ data: Data) -> Self {
        return try! JSONDecoder().decode(Self.self, from: data)
    }
}
