//
//  GameView.swift
//  Multiplayer_3D_TicTacToe
//
//  Created by Thiago Henrique on 04/08/23.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var sessionVM: SessionViewModel
    @State private var errorAlert: AlertError = AlertError()
    @State private var confirmationAlert: ConfirmationAlert = ConfirmationAlert()
    @State private var showChatSheet: Bool = false
    
    var body: some View {
        VStack {
            if sessionVM.gameFlowParameters.gameStarted {
                ServerStatusLabel(
                    label: StatusLabel(
                        text: sessionVM.serverStatus.rawValue,
                        position: .top
                    )
                )
                .padding([.bottom], 120)
            }
            HStack(alignment: .top, spacing: 8) {
                ForEach($sessionVM.gameFlowParameters.boards) { board in
                    TicTacToeBoard(
                        board: board,
                        highlightTiles: sessionVM.winningTiles,
                        inputedStyle: sessionVM.playerIdentifier?.tileStyle ?? .cross,
                        tileTapped: { tile in
                            if !sessionVM.isPlayerShift { return }
                            
                            confirmationAlert = ConfirmationAlert(
                                showAlert: true,
                                description: "Você confirma a colocação do ponto?",
                                action: {
                                    let request = Tictactoe_PlayerMoveRequest.with {
                                        $0.player = sessionVM.playerIdentifier!.toGRPCEntity()
                                        $0.boardID = Int64(tile.boardId)
                                        $0.addedTile = tile.toGRPCEntity()
                                    }
                                    Task {
                                        await sessionVM.manager.sendPlayerMoveMessage(request)
                                    }
                                }
                            )
                        }
                    )
                    .padding([.top], 75 * CGFloat(board.id - 1))
                    .padding([.horizontal], 8)
                    .shadow(
                        color: .black,
                        radius: 8/CGFloat(board.id),
                        x: 12/CGFloat(board.id), y: 12/CGFloat(board.id)
                    )
                }
                .opacity(sessionVM.isPlayerShift || sessionVM.gameFlowParameters.winner != nil ? 1 : 0.2)
                .disabled(!sessionVM.gameFlowParameters.gameStarted || sessionVM.gameFlowParameters.winner != nil)
            }
            
            if sessionVM.gameFlowParameters.gameStarted {
                HStack {
                    Text("Pontos: \(sessionVM.playerIdentifier!.tileStyle.rawValue)")
                        .font(.title)
                        .padding([.leading], 60)
                    Spacer()
                }
                .padding([.top], 80)
            }
        }
        .alert(isPresented: $confirmationAlert.showAlert) {
            Alert(
                title: Text("Ação"),
                message: Text(confirmationAlert.description),
                primaryButton: .default(Text("Confirmar"), action: confirmationAlert.action),
                secondaryButton: .cancel()
            )
        }
        .opacity(sessionVM.showConnectionSheet ? 0.05 : 1)
        .toolbar {
            if sessionVM.gameFlowParameters.gameStarted {
                Button("Chat") {
                    showChatSheet.toggle()
                }
                
                if !sessionVM.gameFlowParameters.gameEnded {
                    Button("Desistir") {
                        confirmationAlert = ConfirmationAlert(
                            showAlert: true,
                            description: "Você confirma a sua desistência?",
                            action: {
                                guard let player = sessionVM.playerIdentifier else { return }
                                Task {
                                    let surrenderRequest = Tictactoe_SurrenderRequest.with {
                                        $0.player = player.toGRPCEntity()
                                    }
                                    await sessionVM.manager.sendSurrenderMessage(surrenderRequest)
                                }
                            }
                        )
                    }
                } else {
                    Button("Jogar Novamente") {
                        Task {
                            await sessionVM.manager.sendRestartMessage()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showChatSheet) {
            if let playerIdentifier = sessionVM.playerIdentifier {
                ChatSheet(
                    identifier: playerIdentifier,
                    messages: sessionVM.chatParameters.messages,
                    sendMessageOnTap: { message in
                        Task {
                            let request = Tictactoe_ChatMessageRequest.with {
                                $0.chatMessage = ChatMessage(
                                    sender: playerIdentifier,
                                    message: message,
                                    sendedDate: Date.now
                                ).toGRPCEntity()
                            }
                            await sessionVM.manager.sendChatMessage(request)
                        }
                    }
                )
                
            }
        }
        .padding([.horizontal], 16)
        .navigationBarBackButtonHidden(true)
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView()
        .environmentObject(SessionViewModel())
    }
}

