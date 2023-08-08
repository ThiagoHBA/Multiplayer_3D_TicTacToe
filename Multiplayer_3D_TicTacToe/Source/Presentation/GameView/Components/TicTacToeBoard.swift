//
//  TicTacToeBoard.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import SwiftUI

struct TicTacToeBoard: View {
    var tiles: [TilePosition]
    var tileStyle: TileStyle
    var boardId: Int
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
                            let tileAvailable = tiles.contains(
                                where: {
                                    $0 == TilePosition(
                                        boardId: boardId,
                                        style: tileStyle,
                                        position: (row, column)
                                    )
                                }
                            )
                            Text(tileAvailable ? tileStyle.rawValue : "")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                                .bold()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .background(.white)
                                .onTapGesture {
                                    if !tileAvailable {
                                        tileTapped?(
                                            TilePosition(
                                                boardId: boardId,
                                                style: tileStyle,
                                                position: (row, column)
                                            )
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
