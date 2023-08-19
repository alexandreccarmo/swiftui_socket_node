//
//  ContentView.swift
//  SocketTest
//
//  Created by Alexandre C do Carmo on 19/08/23.
//

import SwiftUI
import SocketIO

final class Service: ObservableObject {
    private var manager = SocketManager(socketURL: URL(string: "ws://localhost:3000")!, config: [.log(true), .compress])
    
    @Published var messages = [String]()
    
    init() {
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) {(data, ack) in
            print("Conectado")
            socket.emit("NodeJs Server Port", "Olá Node.JS server!")
        }
        
        socket.on("iOS Client Port") { [weak self] (data, ack) in
            if let data = data[0] as? [String: String],
               let rawMessage = data["msg"] {
                DispatchQueue.main.async {
                    self?.messages.append(rawMessage)
                }
            }
        }
        
        socket.connect()
    }
    
    
}

struct ContentView: View {
    
    @ObservedObject var servive = Service()
    
    var body: some View {
        VStack {
            VStack {
                Text("Mensagem recebida do Node.js:")
                    .font(.largeTitle)
                ForEach(servive.messages, id: \.self) {msg in
                    Text(msg).padding()
                }
                Spacer()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
