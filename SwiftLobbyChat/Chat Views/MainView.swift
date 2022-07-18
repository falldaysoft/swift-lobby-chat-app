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
        switch appState.chatManager.lobbyConnectionStatus {
        case .connected:
            ChatView(appState: appState)
        default:
            VStack {
                Text(appState.chatManager.connectionStatus)
            }
                .padding()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(appState: AppState(testMode: true))
    }
}
