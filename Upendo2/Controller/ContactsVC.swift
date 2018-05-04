//
//  ContactsVC.swift
//  Upendo2
//
//  Created by Kerwin Charles on 12/20/17.
//  Copyright © 2017 Kerwin Charles. All rights reserved.
//

import UIKit

class ContactsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FetchData {
    @IBOutlet weak var myTable: UITableView!
    
    private let CELL_ID = "Cell";
    private let CHAT_SEGUE = "ChatSegue";
    private var contacts = [Contact]();
    //@IBOutlet weak var myTable: UITableView!
    //@IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        DBProvider.Instance.delegate = self;
        DBProvider.Instance.getContacts();
    }
    func dataReceived(contacts: [Contact]) {
        self.contacts = contacts;
        
        for contact in contacts{
            
        if contact.id == AuthProvider.Instance.userID(){
            AuthProvider.Instance.userName = contact.name;
            }
            }
        myTable.reloadData();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath);
        cell.textLabel?.text = "THIS WORKS!"
        
        cell.textLabel?.text = contacts[indexPath.row].name;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: CHAT_SEGUE, sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logout(_ sender: Any) {
        if AuthProvider.Instance.logOut(){
            dismiss(animated: true, completion: nil)
        }else{
            self.alertTheUser(title: "Problem while logging out", message: "Please try again")
        }
    }
    private func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
} // class
