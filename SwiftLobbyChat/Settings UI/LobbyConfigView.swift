//
//  LobbyConfigView.swift
//  SwiftLobbyChat
//
//  Created by Steve Tibbett on 2022-08-01.
//

import SwiftUI

struct LobbyConfigView: View {
    var chatManager: ChatManager
    @State var lobbyServer = ""
    @State var lobbyCode = ""

    var body: some View {
        Spacer()
        VStack {
            Spacer()
            Form {
                Section {
                    TextField("Server Address", text: $lobbyServer)
                    TextField("Lobby Code", text: $lobbyCode)
                }
                Section {
                    Button("Connect") {
                        chatManager.lobbyServer = lobbyServer
                        chatManager.lobbyCode = lobbyCode
                        chatManager.connect()
                    }
                }
            }
            Spacer()
        }
        Spacer()
    }
}
