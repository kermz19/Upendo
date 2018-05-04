//
//  CreateProfileVC.swift
//  Upendo2
//
//  Created by Kerwin Charles on 5/3/18.
//  Copyright © 2018 Kerwin Charles. All rights reserved.
//

import UIKit

var name = "";
var education = "";
var origin = "";
var generation = "";
var bio = "";

class CreateProfileVC: UIViewController {
    let PROFILE_SEGUE = "ProfileSegue";
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var educationField: UITextField!
    @IBOutlet weak var originField: UITextField!
    @IBOutlet weak var generationField: UITextField!
    @IBOutlet weak var bioField: UITextView!
    @IBAction func createProfileBtn(_ sender: AnyObject) {
        
        name = nameField.text!;
        education = educationField.text!;
        origin = originField.text!;
        generation = generationField.text!
        bio = bioField.text!
        
        performSegue(withIdentifier: PROFILE_SEGUE, sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
