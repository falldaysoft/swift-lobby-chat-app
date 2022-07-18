//
//  ChatMessageView.swift
//  SwiftLobbyChat
//
//  Created by Steve Tibbett on 2022-07-17.
//

import SwiftUI

struct ChatMessageView: View {
    var message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isCurrentUser { Spacer() }
            Text(message.message)
                .padding(10)
                .foregroundColor(message.isCurrentUser ? Color.white : Color.black)
                .background(message.isCurrentUser ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                .cornerRadius(10)
            if !message.isCurrentUser { Spacer() }
        }.frame(maxWidth: .infinity)
    }
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView(message: ChatMessage(id: UUID(), isCurrentUser: true, message: "Current User", date: Date()))
        ChatMessageView(message: ChatMessage(id: UUID(), isCurrentUser: true, message: "Other User", date: Date()))
    }
}
