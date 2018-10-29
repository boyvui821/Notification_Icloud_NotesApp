//
//  ViewController.swift
//  Notification_Icloud_NotesApp
//
//  Created by Nguyen Hieu Trung on 10/27/18.
//  Copyright © 2018 OneSignal. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    @IBOutlet weak var tableNotes: UITableView!
    
    var notes:[Note] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        CKService.shared.subcribeWithUI()
        UNService.shared.authorize()
        tableNotes.dataSource = self;
        
        getNote();
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFetch), name: NSNotification.Name("InternalNotification.fetchRecord"), object: nil)
    }
    
    func getNote(){
        NotesService.getNotes { (arrNote) in
            self.notes = arrNote
            self.tableNotes.reloadData()
        }
    }

    @IBAction func PressEdit(_ sender: Any) {
        AlertService.composeNote(in: self) { (note) in
            //self.tableNotes.reloadData()
            CKService.shared.save(record: note.noteRecord())
            self.insertRow(note: note)
        }
    }
    
    func insertRow(note: Note){
        notes.insert(note, at: 0)
        let index = IndexPath(row: 0, section: 0)
        tableNotes.insertRows(at: [index], with: UITableView.RowAnimation.fade)
    }
    
    @objc func handleFetch(_ sender:Notification){
        print("--Func handleFetch--")
        guard let record = sender.object as? CKRecord,
        let note = Note(record: record)
        else {return}
        insertRow(note: note)
    }
    
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let note = notes[indexPath.row];
        cell.textLabel?.text = note.title
        return cell
    }
    
    
}

