//
//  AlertService.swift
//  Notification_Icloud_NotesApp
//
//  Created by Nguyen Hieu Trung on 10/27/18.
//  Copyright © 2018 OneSignal. All rights reserved.
//

import Foundation
import UIKit

class AlertService{
    private init(){}
    static func composeNote(in vc:UIViewController, completion: @escaping (Note)->Void){
        let alertController = UIAlertController(title: "New Note", message: "What 's your mind?", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        
        let actionPost = UIAlertAction(title: "Post", style: .default) { (alertAction) in
            guard let title = alertController.textFields?.first?.text else {return}
            
            let note = Note(title: title)
            completion(note)
        }
        
        alertController.addAction(actionPost)
        vc.present(alertController, animated: true, completion: nil)
    }
}
