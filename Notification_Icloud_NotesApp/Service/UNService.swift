//
//  UNService.swift
//  Notification_Icloud_NotesApp
//
//  Created by Nguyen Hieu Trung on 10/29/18.
//  Copyright © 2018 OneSignal. All rights reserved.
//

import Foundation
import UserNotifications

class UNService:NSObject{
    private override init(){}
    static let shared = UNService()
    let center = UNUserNotificationCenter.current()
    
    func authorize(){
        center.requestAuthorization(options: [.alert,.sound,.badge,.carPlay]) { (status, error) in
            if error != nil{
                print("Error UserNotification authorize: \(error?.localizedDescription) ")
                return
            }
            self.configure()
        }
    }
    
    func configure(){
        center.delegate = self;
    }
}

extension UNService: UNUserNotificationCenterDelegate{
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("--userNotificationCenter didReceive--")
        
        CKService.shared.handleNotification(with: response.notification.request.content.userInfo)
        completionHandler()
    }
    
    // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("--userNotificationCenter willPresent--")
        let options = UNNotificationPresentationOptions(arrayLiteral: [.alert,.sound]);
        completionHandler(options)
    }
    
    
    
}


