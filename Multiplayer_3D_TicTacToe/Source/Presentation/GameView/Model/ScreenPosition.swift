//
//  ScreenPosition.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 16/08/23.
//

import Foundation

enum ScreenPosition {
    case top
    case center
    case bottom
    
    func screenOffSet(size: CGSize) -> CGFloat {
        switch self {
        case.center:
            return size.height * 0
        case .top:
            return -size.height * 0.3
        case .bottom:
            return size.height * 0.3
        }
    }
}
