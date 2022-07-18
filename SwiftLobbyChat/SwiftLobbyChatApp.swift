//
//  SwiftLobbyChatApp.swift
//  SwiftLobbyChat
//
//  Created by Steve Tibbett on 2022-07-17.
//

import SwiftUI

@main
struct SwiftLobbyChatApp: App {
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            MainView(appState: appState)
        }
    }
}
