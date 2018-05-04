//
//  ChatVC.swift
//  Upendo2
//
//  Created by Kerwin Charles on 12/20/17.
//  Copyright © 2017 Kerwin Charles. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import SDWebImage

class ChatVC: JSQMessagesViewController, MessageReceivedDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let CREATE_PROFILE_SEGUE = "CreateProfileSegue";
    private var messages = [JSQMessage]();
    
    let picker = UIImagePickerController();
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self;
        MessagesHandler.Instance.delegate = self;
        // Do any additional setup after loading the view.
        
        self.senderId = AuthProvider.Instance.userID();
        self.senderDisplayName = AuthProvider.Instance.userName;
        
        MessagesHandler.Instance.observeMessages()
        MessagesHandler.Instance.observeMediaMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        // gets the item at that row
        let msg = messages[indexPath.item];
        
        if msg.isMediaMessage{
            if let mediaItem = msg.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: mediaItem.fileURL);
                let playerController = AVPlayerViewController();
                playerController.player = player;
                self.present(playerController, animated: true,
                             completion:nil);
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell;
    }
    // MARK: - Navigation

    
    // End Collection View functions
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory();
     //   let message = messages[indexPath.item];
        
        if senderId == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue)
        }else{
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.blue)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil;
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        MessagesHandler.Instance.sendMessage(senderID: senderId, senderName: senderDisplayName, text: text);
        
        // removes text from text field
        finishSendingMessage();
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let alert = UIAlertController(title: "Media Messages", message: "Please Select Media", preferredStyle: .actionSheet);
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        let photos = UIAlertAction(title: "Photos", style: .default, handler: {(action: UIAlertAction) in
            self.chooseMedia(type: kUTTypeImage);
            
        })
        
        let videos = UIAlertAction(title: "Videos", style: .default, handler: {(action: UIAlertAction) in
            
            self.chooseMedia(type: kUTTypeMovie);
            
        })
        
        alert.addAction(photos);
        alert.addAction(videos);
        alert.addAction(cancel);
        present(alert, animated:true, completion: nil);
    }
    
    // End sending buttons functions
    
    // Picker view functions
    private func chooseMedia(type: CFString) {
        
        picker.mediaTypes = [type as String];
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            let data = UIImageJPEGRepresentation(pic, 0.01)
            
            MessagesHandler.Instance.sendMedia(image: data, video: nil, senderID: senderId, senderName: senderDisplayName);
        }else if let vidURL = info[UIImagePickerControllerMediaURL] as? URL{
          
            MessagesHandler.Instance.sendMedia(image: nil, video: vidURL, senderID: senderId, senderName: senderDisplayName);
        }
        
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData();
    }
    
    // End Picker view functions
    
    // Delegation Function
    func messageReceived(senderID: String, text: String) {
        messages.append(JSQMessage(senderId: senderID, displayName: "empty", text: text));
        collectionView.reloadData();
    }
    
    func mediaReceived(senderID: String, senderName: String, url: String){
        
        if let mediaURL = URL(string: url){
            
            do{
                // tries to set data to type of mediaURL
                let data = try Data(contentsOf: mediaURL);
                
                if let _ = UIImage(data: data) {
                    let _ = SDWebImageDownloader.shared().downloadImage(with: mediaURL, options: [], progress: nil, completed: { (image, data, error, finished) in
                        DispatchQueue.main.async {
                            let photo = JSQPhotoMediaItem(image: image);
                            if senderID == self.senderId {
                                photo?.appliesMediaViewMaskAsOutgoing = true;
                            }else{
                                print("IN HERE")
                                photo?.appliesMediaViewMaskAsOutgoing = false;
                            }
                            self.messages.append(JSQMessage(senderId: senderID, displayName: senderName, media: photo));
                            self.collectionView.reloadData();
                    
                         }
                        
                    })
                }else{
                    
                }
            }catch{
                
            }
            
        }
    }
    
    // End Delegation Function
    
    @IBAction func createProfileScreen(_ sender: Any) {

        performSegue(withIdentifier: CREATE_PROFILE_SEGUE, sender: self)
    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    
}// class
