//
//  TicTacToeBoard.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import SwiftUI

struct TicTacToeBoard: View {
    var tiles: [Tile]
    var boardId: Int
    var inputedStyle: TileStyle
    var backgroundColor: Color
    var tileTapped: ((TilePosition) -> ())?
    
    var body: some View {
        ZStack {
            Rectangle()
                .background(backgroundColor)
                .cornerRadius(12)
            
            VStack(spacing: 10.0) {
                ForEach(0...2, id: \.self) { row in
                    HStack(spacing: 10.0) {
                        ForEach(0...2, id: \.self) { column in
                            let tileAvailable = tiles.contains(where: {
                                $0.position == TilePosition(row: row, column: column) &&
                                $0.boardId == boardId
                            })
                            Text(tileAvailable ? inputedStyle.rawValue : "")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                                .bold()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .background(.white)
                                .onTapGesture {
                                    if !tileAvailable {
                                        tileTapped?(
                                            TilePosition(row: row, column: column)
                                        )
                                    }
                                }
                        }
                    }
                }
            }
            .background(.black)
            .padding(12)
        }
        .frame(width: 180, height: 180)
    }
}
