//
//  CKService.swift
//  Notification_Icloud_NotesApp
//
//  Created by Nguyen Hieu Trung on 10/27/18.
//  Copyright © 2018 OneSignal. All rights reserved.
//

import Foundation
import CloudKit

class CKService{
    private init (){}
    static let shared = CKService()
    
    let database = CKContainer.default().publicCloudDatabase
    func save(record:CKRecord){
        database.save(record) { (ckRecord, error) in
            if error != nil{
                print("Error save record: \(error)")
            }
        }
    }
    
    func query(recordType: String, completion:@escaping ([CKRecord])->Void){
        var query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (arrRecor, error) in
            guard let records = arrRecor else {return}
            DispatchQueue.main.async {
                completion(records)
            }
        }
    }
    
    //Lắng nghe sự thay đổi của database
    func subcripbe(){
        //Kiểm tra xoá sup
        database.fetchAllSubscriptions { (subscriptions, error) in
            if subscriptions != nil{
                for subcription in subscriptions!{
                    self.database.delete(withSubscriptionID: subcription.subscriptionID, completionHandler: { (id, error) in
                        if error != nil{
                            
                        }
                        
                    })
                }
            }
            
            let subcribe = CKQuerySubscription(recordType: Note.recordType,
                                               predicate: NSPredicate(value: true),
                                               options: .firesOnRecordCreation)
            let notificationInfo = CKSubscription.NotificationInfo()
            notificationInfo.shouldSendContentAvailable = true
            subcribe.notificationInfo = notificationInfo
            self.database.save(subcribe) { (ckSubcription, error) in
                if error != nil {
                    print("Subcripbe error: \(error?.localizedDescription)")
                }
            }
        }

        
    }
    
    func subcribeWithUI(){
        database.fetchAllSubscriptions { (subscriptions, error) in
            if subscriptions != nil{
                for subcription in subscriptions!{
                    self.database.delete(withSubscriptionID: subcription.subscriptionID, completionHandler: { (id, error) in
                        if error != nil{
                            
                        }
                        
                    })
                }
            }
            
            let subcribe = CKQuerySubscription(recordType: Note.recordType,
                                               predicate: NSPredicate(value: true),
                                               options: .firesOnRecordCreation)
            let notificationInfo = CKSubscription.NotificationInfo()
            if #available(iOS 11.0, *) {
                notificationInfo.title = "This is Cool"
                notificationInfo.subtitle = "A Whole new Icloud"
                notificationInfo.alertBody = "Có thư mới ae ơi"
                notificationInfo.shouldBadge = true;
                notificationInfo.soundName = "default"
            } else {
                // Fallback on earlier versions
            }
            
            
            notificationInfo.shouldSendContentAvailable = true
            subcribe.notificationInfo = notificationInfo
            self.database.save(subcribe) { (ckSubcription, error) in
                if error != nil {
                    print("Subcripbe error: \(error?.localizedDescription)")
                }
            }
        }
    }
    
    func fetchRecor(with recordID: CKRecord.ID){
        database.fetch(withRecordID: recordID) { (ckRecord, error) in
            guard let record = ckRecord else {return}
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("InternalNotification.fetchRecord"), object: record)
            }
        }
    }
    
    func handleNotification(with userInfo: [AnyHashable:Any]){
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        switch notification.notificationType {
        case .query:
            guard let notification = notification as? CKQueryNotification,let recordID = notification.recordID
                else {return}
            
            fetchRecor(with: recordID)
        default:
            return
        }
    }
}
