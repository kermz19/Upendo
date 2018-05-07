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

class CreateProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let PROFILE_SEGUE = "ProfileSegue";
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var educationField: UITextField!
    @IBOutlet weak var originField: UITextField!
    @IBOutlet weak var generationField: UITextField!
    @IBOutlet weak var bioField: UITextView!
    
    /*
    // MARK: - Actions
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController();
        
        imagePickerController.sourceType = .photoLibrary

        imagePickerController.delegate = self as UIImagePickerControllerDelegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate;
        present(imagePickerController, animated: true, completion: nil);
    }
    
    @IBAction func createProfileBtn(_ sender: AnyObject) {
        
        name = nameField.text!;
        education = educationField.text!;
        origin = originField.text!;
        generation = generationField.text!
        bio = bioField.text!
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: PROFILE_SEGUE) as! ProfileVC
        myVC.theImagePassed = photoImageView.image!
        navigationController?.pushViewController(myVC, animated: true)
        
        performSegue(withIdentifier: PROFILE_SEGUE, sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray;
        self.view.tintColor = UIColor.blue;

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
