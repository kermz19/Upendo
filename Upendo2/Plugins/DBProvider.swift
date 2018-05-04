//
//  DBProvider.swift
//  Upendo2
//
//  Created by Kerwin Charles on 1/5/18.
//  Copyright © 2018 Kerwin Charles. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol FetchData: class {
    
    func dataReceived(contacts: [Contact]);
}

class DBProvider{
    
    private static let _instance = DBProvider();
    
    // ensures no other class can create an instance of DBProvider class
    private init() {}
    
    weak var delegate: FetchData?;
    
    static var Instance: DBProvider{
        return _instance;
    }
    
    var dbRef: DatabaseReference {
        
        //returns Database info
        return Database.database().reference();
    }
    
    
    // storage of images, videos and other files
    var storageRef: StorageReference{
        return Storage.storage().reference(forURL: "gs://upendo-b7333.appspot.com");
    }
    
    
    var contactsRef: DatabaseReference{
        return dbRef.child(Constants.CONTACTS);
    }
    
    var messagesRef: DatabaseReference{
        return dbRef.child(Constants.MESSAGES);
    }
    
    var mediaMessagesRef: DatabaseReference{
        return dbRef.child(Constants.MEDIA_MESSAGES);
    }
    
    var imageStorageRef: StorageReference {
        return storageRef.child(Constants.IMAGE_STORAGE);
    }
    
    var videoStorageRef: StorageReference {
        return storageRef.child(Constants.VIDEO_STORAGE);
    }
    
    func saveUser(withID: String, email: String, password: String){
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password];
        
        contactsRef.child(withID).setValue(data);
    }
    
    func getContacts() -> [Contact]{
        var contacts = [Contact]();
        contactsRef.observeSingleEvent(of: DataEventType.value){
            (snapshot: DataSnapshot) in
            
            if let myContacts = snapshot.value as? NSDictionary{
                
                for (key, value) in myContacts {
                    if let contactData = value as? NSDictionary {
                        if let email = contactData[Constants.EMAIL] as? String {
                            let id = key as! String;
                            let newContact = Contact(id: id, name: email);
                            contacts.append(newContact);
                            
                        }
                    }
                }
            }
            self.delegate?.dataReceived(contacts: contacts);
        }
        return contacts;
    }
    
    // func getMessages() -> [Message]{}
        
        
   

    
    
    
} // class
