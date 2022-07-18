//
//  ChatMessage.swift
//  SwiftLobbyChat
//
//  Created by Steve Tibbett on 2022-07-17.
//

import Foundation

struct ChatMessage: Identifiable, Hashable {
    var id = UUID()
    var isCurrentUser = false
    var message: String
    var date: Date
}
