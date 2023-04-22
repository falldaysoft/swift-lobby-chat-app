//
//  ChatManager.swift
//  SwiftLobbyChat
//
//  Created by Steve Tibbett on 2022-07-17.
//

import Foundation
import SwiftLobbyClient
import SwiftUI

protocol ChatManagerDelegate {
    func connectionStatusChanged()
    func messagesChanged()
}

class ChatManager: ObservableObject {
    var testMode = false
    
    var messages = [ChatMessage]()
    var lobbyConnectionStatus = LobbyConnectionStatus.notConnected

    var connectionStatus: String = NSLocalizedString("Not connected", comment: "Lobby status")
    
    @AppStorage("lobbyServer") var lobbyServer: String = ""
    @AppStorage("lobbyCode") var lobbyCode: String = ""

    var lobbyClient: LobbyClient?
    var delegate: ChatManagerDelegate?
    var notificationManager: NotificationManager
    
    init(notificationManager: NotificationManager, delegate: ChatManagerDelegate?, testMode: Bool) {
        self.notificationManager = notificationManager
        
        self.testMode = testMode
        self.delegate = delegate
        
        if testMode {
            messages = [
                ChatMessage(id: UUID(), isCurrentUser: true, message: "Hello", date: Date()),
                ChatMessage(id: UUID(), isCurrentUser: false, message: "Hi there.", date: Date()),
                ChatMessage(id: UUID(), isCurrentUser: true, message: "How can I help you?", date: Date()),
                ChatMessage(id: UUID(), isCurrentUser: false, message: "I need a hint.", date: Date())
            ]
        }

        connect()
    }

    func connect() {
        if !lobbyServer.isEmpty && !lobbyCode.isEmpty {
            var urlString = lobbyServer
            if !urlString.hasPrefix("ws") && !urlString.hasPrefix("wss") {
                urlString = "wss://\(lobbyServer)"
            }

            if let url = URL(string: urlString)  {
                lobbyClient = LobbyClient(server: url, lobbyCode: lobbyCode, delegate: self)
            } else {
                // Can't connect, no URL
            }
        }
    }
    
    func send(_ message: IncomingPlayerMessage) async {
        await lobbyClient?.send(message)
    }
}

extension ChatManager: LobbyClientDelegate {
    func lobbyStatusDidChange(lobbyClient: LobbyClient, status: LobbyConnectionStatus) {
        print("LobbyStatusDidChange: \(status)")
        self.lobbyConnectionStatus = status
        
        switch status {
        case .notConnected:
            connectionStatus = NSLocalizedString("Not connected", comment: "Lobby status")
        case .connecting:
            connectionStatus = NSLocalizedString("Connecting", comment: "Lobby status")
        case .connected:
            connectionStatus = NSLocalizedString("Connected", comment: "Lobby status")
        case .failed(localizedMessage: let localizedMessage):
            if let localizedMessage = localizedMessage {
                connectionStatus = NSLocalizedString("Error: \(localizedMessage)", comment: "Lobby status")
            } else {
                connectionStatus = NSLocalizedString("Unable to connect", comment: "Lobby status")
            }
        case .reconnecting:
            connectionStatus = NSLocalizedString("Reconnecting", comment: "Lobby status")
        }
        
        self.delegate?.connectionStatusChanged()
    }
    
    func lobbyDidReceiveMessage(lobbyClient: LobbyClient, message: OutgoingPlayerMessage) {
        switch message {
        case .say(let text, let date, let fromPlayerNum):
            messages.append(ChatMessage(id: UUID(), isCurrentUser: fromPlayerNum == lobbyClient.ourPlayerNum, message: text, date: date))
            self.delegate?.messagesChanged()
            break
        default:
            break
        }
    }
    
    func lobbyDidDisconnect(lobbyClient: LobbyClient) {
        self.delegate?.connectionStatusChanged()
    }
}
