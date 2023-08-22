//
//  TicTacToeBoard.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 07/08/23.
//

import SwiftUI

struct TicTacToeBoard: View {
    @Binding var board: Board
    var inputedStyle: TileStyle
    var tileTapped: ((Tile) -> ())?
    
    var body: some View {
        ZStack {
            VStack(spacing: 10.0) {
                ForEach(0...2, id: \.self) { row in
                    HStack(spacing: 10.0) {
                        ForEach(0...2, id: \.self) { column in
                            let tile = board.tiles.first( where: {
                                $0.position == TilePosition(
                                    row: row,
                                    column: column,
                                    depth: board.id
                                )
                            })
                            Text(tile?.style.rawValue ?? "")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                                .bold()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .background(board.color.toSwiftUIColor())
                                .onTapGesture {
                                    if tile == nil {
                                        tileTapped?(
                                            Tile(
                                                boardId: board.id,
                                                style: inputedStyle,
                                                position: TilePosition(
                                                    row: row,
                                                    column: column,
                                                    depth: board.id
                                                )
                                            )
                                        )
                                    }
                                }
                        }
                    }
                }
            }
            .background(.clear)
            .padding(12)
        }
        .frame(height: 180)
        .cornerRadius(12)
    }
}


struct TicTacToeBoard_Previews: PreviewProvider {
    
    static var previews: some View {
        TicTacToeBoard(
            board: .constant(Board(id: 1, color: .blue, tiles: [])),
            inputedStyle: .circle
        )
    }
}



