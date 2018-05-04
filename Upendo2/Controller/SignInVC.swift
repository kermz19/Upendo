//
//  ViewController.swift
//  Upendo2
//
//  Created by Kerwin Charles on 12/19/17.
//  Copyright © 2017 Kerwin Charles. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInVC: UIViewController {
    
    private let CONTACTS_SEGUE = "ContactsSegue"
    
    @IBOutlet weak var emailTextfField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
            self.performSegue(withIdentifier: CONTACTS_SEGUE, sender: nil);
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: Any) {
        
        
        if emailTextfField.text != "" && passwordTextField.text != "" {
        
        AuthProvider.Instance.login(withEmail: emailTextfField.text!, password: passwordTextField.text!, loginHandler: {(message) in

            if message != nil {
                self.alertTheUser(title: "Problem with Authentication", message: message!);
            }else{
                print("Login Completed");
                self.performSegue(withIdentifier: self.CONTACTS_SEGUE, sender: nil)
            }
        });
        }else{
            self.alertTheUser(title: "Email and password are required", message: "Please enter email and password in the text fields")
        }
        
    }
    @IBAction func signUp(_ sender: Any) {
        
        if emailTextfField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailTextfField.text! , password: passwordTextField.text!, loginHandler: {(message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem with creating the user", message: message!);
                }else{
                    print("creating user completed")
                    
                    self.emailTextfField.text = "";
                    self.passwordTextField.text = "";
                    
                    
                    // segue to other view controller
                    self.performSegue(withIdentifier: self.CONTACTS_SEGUE, sender: nil)
                    
                }
            });
        }else{
            self.alertTheUser(title: "Email and password are required", message: "Please enter email and password in the text fields");
        }
    }
    
    private func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
}

