//
//  ChatView.swift
//  SwiftLobbyChat
//
//  Created by Steve Tibbett on 2022-07-17.
//

import SwiftUI
import SwiftLobbyClient

struct ChatView: View {
    @ObservedObject var appState: AppState
    @State var typingMessage: String = ""
    
    private enum Field: Int, Hashable {
        case messageText
        case send
    }
    
    @FocusState private var focusField: Field?
    
    func sendMessage() {
        let msg = typingMessage
        typingMessage = ""
        Task {
            await appState.chatManager.send(IncomingPlayerMessage.say(text: msg))
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { reader in
                    ForEach(appState.messages, id: \.self) { message in
                        ChatMessageView(message: message)
                            .id(message.id)
                    }
                    .padding()
                    .onChange(of: appState.messages.count) { count in
                        withAnimation {
                            reader.scrollTo(appState.messages.last!.id)
                        }
                    }
                }
            }
            
            HStack {
                TextField("Message", text: $typingMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: CGFloat(24))
                    .onSubmit {
                        sendMessage()
                        focusField = .messageText
                    }
                    .focused($focusField, equals: .messageText)
                Button(action: sendMessage) {
                    Text("Send")
                }
                .focused($focusField, equals: .send)
            }.frame(minHeight: CGFloat(40)).padding()
        }.frame(maxHeight: .infinity)
            .onAppear {
                focusField = .messageText
            }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(appState: AppState(testMode: true))
            .previewInterfaceOrientation(.portrait)
            .previewDevice("iPhone 8")
    }
}
