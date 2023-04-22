//
//  AppState.swift
//  SwiftLobbyChat
//
//  Created by Steve Tibbett on 2022-07-17.
//

import Foundation
import SwiftUI
import SwiftLobbyClient

/**
 AppState creates the ChatManager, and acts as a delegate, hosting the properties
 so SwiftUI can bind to them.  Having a separarate ViewModel for each view and
 using listeners, or broadcasting notifications, would be cleaner but this is a pretty
 simple app.
 */
class AppState: ObservableObject {
    var testMode = false
    @Published var chatManager: ChatManager
    var notificationManager: NotificationManager

    @Published var connectionStatus = LobbyConnectionStatus.notConnected
    @Published var messages = [ChatMessage]()
    
    init(testMode: Bool = false) {
        self.notificationManager = NotificationManager()
        self.testMode = testMode
        self.chatManager = ChatManager(notificationManager: self.notificationManager,
                                       delegate: nil,
                                       testMode: testMode)
        self.messages = self.chatManager.messages
        self.chatManager.delegate = self
    }
}

extension AppState: ChatManagerDelegate {
    func connectionStatusChanged() {
        self.connectionStatus = chatManager.lobbyConnectionStatus
    }
    
    func messagesChanged() {
        self.messages = chatManager.messages
        self.notificationManager.notify()
    }
}
