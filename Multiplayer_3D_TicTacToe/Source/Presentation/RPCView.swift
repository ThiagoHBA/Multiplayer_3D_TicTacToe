////
////  RPCView.swift
////  Multiplayer_3D_TicTacToe
////
////  Created by Thiago Henrique on 26/09/23.
////
//
//import SwiftUI
//import GRPC
//
//struct RPCView: View {
//    @State var server: TicTacToeRPCServer!
//    @State var client: TicTacToeRPCClient!
//    @State var inputPort: String = String()
//    @State var port: String = String()
//    @State var messageToSend = String()
//
//    var body: some View {
//        Text("Porta: \(port)")
//            .font(.largeTitle)
//            .padding([.bottom], 80)
//        
//        Button("Start Server") {
//            DispatchQueue.global(qos: .background).async {
//                server = TicTacToeRPCServer()
//                server.run(completion: { port in
//                    self.port = String(port)
//                })
//            }
//        }
//        .padding([.bottom], 80)
//        
//        TextField("Connectar a porta", text: $inputPort)
//            .frame(maxWidth: 150)
//            .padding(12)
//        
//        Button("Conectar") {
//            DispatchQueue.global(qos: .background).async {
//                client = TicTacToeRPCClient {
//                    client.connectToServer(
//                        port: Int(port)!,
//                        completion: { value in }
//                    )
//                }
//            }
//        }
//        .padding([.bottom], 60)
//        
//        TextField("Message to send", text: $messageToSend)
//            .frame(maxWidth: 150)
//            .padding(12)
//        
//        Button("Send Message") {
//            Task {
//                try! await client.service.chat(
//                    .with {
//                        $0.sender = "\(server.port)"
//                        $0.content = messageToSend
//                    }
//                )
//            }
//        }
//    }
//}
////    @StateObject var vm = ObservableClass()
////    @State var serverState: String = "Waiting..."
////    @State var serverCode: String = String()
////
////        VStack {
////            VStack {
////                Text("Messages:")
////                    .font(.title)
////                    .bold()
////                ForEach(vm.messages) { incomingMessage in
////                    Text(incomingMessage.message)
////                }
////            }
////            
////            Text(serverState)
////                .font(.title)
////                .padding([.bottom], 50)
////            
////            Button("Start Server") {
////                DispatchQueue.global(qos: .background).async {
////                    server = TicTacToeRPCServer()
////                    server.startServer(completion: { _ in
////                        serverState = "Server started at: \(server.serverPath)"
////                        client = TicTacToeRPCClient(completion: {
////                            client.connectToServer(path: serverCode) { _ in
////                                serverState = "Connected in server"
////                            }
////                        })
////                    })
////                }
////            }
////            
////            TextField("Server Code", text: $serverCode)
////                .frame(maxWidth: 150)
////                .padding(12)
////            
////            Button("Connect to server") {
////                DispatchQueue.global(qos: .background).async {
////                    client = TicTacToeRPCClient(completion: {
////                        client.connectToServer(path: serverCode) { _ in
////                            serverState = "Connected in server"
////                        }
////                    })
////                }
////            }
////            
////            Button("Send chat message as server") {
////                Task {
////                    
////                }
////            }
////            
////            Button("Send chat message as client") {
////                Task {
////                    await client.sendChatStreamMessage()
////                }
////                
////            }
////            Button("Send connect to server") {
////                Task {
////                    serverState = "Sending connection message"
////                    _ = await client.sendConnectedMessage()
////                    serverState = "Connected received"
////                }
////            }
////        }
////    }
////}
////
////class ObservableClass: ObservableObject {
////    var messages: [ChatMessage] = []
////}
////
////extension ObservableClass: ClientOutput {
////    func errorWhileReceivingMessage(_ error: Error) {
////        
////    }
////    
////    func didUpdateSessionParameters(_ newState: GameFlowParameters) {
////        
////    }
////    
////    func didConnectInServer(_ identifier: Player) {
////        
////    }
////    
////    func didGameStart() {
////        
////    }
////    
////    func didFinishPlayerMove(on boardId: Int, in tile: Tile) {
////        
////    }
////    
////    func didChangeShift(_ newShiftPlayer: Int) {
////        
////    }
////    
////    func didEndGame(_ winner: Player, surrender: Bool, winningTiles: [TilePosition]) {
////        
////    }
////    
////    func didReceiveAChatMessage(_ message: ChatMessage) {
////        messages.append(message)
////    }
////}
