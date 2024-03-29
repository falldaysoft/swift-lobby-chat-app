//
//  ContentView.swift
//  SwiftLobbyChat
//
//  Created by Steve Tibbett on 2022-07-17.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        if appState.chatManager.lobbyCode.isEmpty ||
            appState.chatManager.lobbyServer.isEmpty
        {
            // Configure
            LobbyConfigView(chatManager: appState.chatManager)
        } else {
            switch appState.chatManager.lobbyConnectionStatus {
            case .connected:
                ChatView(appState: appState)
            default:
                VStack {
                    Text(appState.chatManager.connectionStatus)
                }
                    .padding()
                Button("Select a Server") {
                    appState.chatManager.lobbyCode = ""
                    appState.chatManager.lobbyServer = ""
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(appState: AppState(testMode: true))
    }
}
