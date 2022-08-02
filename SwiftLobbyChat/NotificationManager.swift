//
//  NotificationManager.swift
//  SwiftLobbyChat
//
//  Created by Steve Tibbett on 2022-07-20.
//

import Foundation
import UIKit

class NotificationManager {
    private var userNotificationCenter = UNUserNotificationCenter.current()
    
    func notify() {
        // Create new notifcation content instance
        let notificationContent = UNMutableNotificationContent()
        
        // Add the content to the notification content
        notificationContent.title = "New Message"
        notificationContent.body = "A new message has arrived"
        notificationContent.badge = 1
        
        let request = UNNotificationRequest(identifier: "message", content: notificationContent, trigger: nil)
        userNotificationCenter.add(request)
    }
        
    
    private func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    init() {
        requestNotificationAuthorization()
    }
}
