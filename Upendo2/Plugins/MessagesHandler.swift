//
//  MessagesHandler.swift
//  Upendo2
//
//  Created by Kerwin Charles on 4/6/18.
//  Copyright © 2018 Kerwin Charles. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol MessageReceivedDelegate: class {
    func messageReceived(senderID: String, text: String);
    
}

class MessagesHandler {
    private static let _instance = MessagesHandler();
    private init() {}
    
    weak var delegate: MessageReceivedDelegate?;
    
    static var Instance: MessagesHandler {
        return _instance;
    }
    
    func sendMessage(senderID: String, senderName: String, text: String){
        
        let data: Dictionary<String, Any> = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.TEXT: text];
        
        DBProvider.Instance.messagesRef.childByAutoId().setValue(data);
    }
    func sendMediaMessage(senderID: String, senderName: String, url: String){
        
        let data: Dictionary<String, Any> = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.URL: url];
        
        DBProvider.Instance.mediaMessagesRef.childByAutoId().setValue(data);
        
    }
    func sendMedia(image: Data?, video: URL?, senderID: String, senderName: String) {
        
        if image != nil {
            DBProvider.Instance.imageStorageRef.child(senderID + "\(NSUUID().uuidString).jpg").putData(image!, metadata: nil) { (metadata: StorageMetadata?, err:Error?)
                in
                
                if err != nil {
                    // inform the user that there was a problem uploading the image
                }else{
                    self.sendMediaMessage(senderID: senderID, senderName: senderName, url: String(describing: metadata!.downloadURL()!));
                    
                }
            }
        }else{
            DBProvider.Instance.videoStorageRef.child(senderID + "\(NSUUID().uuidString)").putFile(from: video!, metadata: nil) { (metadata: StorageMetadata?, err: Error?) in
                
                if err != nil {
                    // inform the user that uploading the video has failed
                    // do this by using delegation
                }else {
                    self.sendMediaMessage(senderID: senderID, senderName: senderName, url: String(describing: metadata!.downloadURL()!));
                    
                }
            }
        }
    }
    
    func observeMessages() {
        DBProvider.Instance.messagesRef.observe(DataEventType.childAdded) {
            (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let senderID = data[Constants.SENDER_ID] as? String {
                    if let text = data[Constants.TEXT] as? String {
                        self.delegate?.messageReceived(senderID: senderID, text: text)
                    }
                }
            }
        }
    }
    
    
    func observeMediaMessages(){
        
        // mediaMessagesRef is where we get the data from
        // .observe acts as a listener
        DBProvider.Instance.mediaMessagesRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
            
        }    }
}// class

















