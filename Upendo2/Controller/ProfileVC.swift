//
//  ProfileVC.swift
//  Upendo2
//
//  Created by Kerwin Charles on 5/3/18.
//  Copyright © 2018 Kerwin Charles. All rights reserved.
//

import UIKit
import Foundation

class ProfileVC: UIViewController {
    
    var theImagePassed = UIImage();
    
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var generationLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        nameLabel.text = name;
        educationLabel.text = education;
        originLabel.text = origin;
        generationLabel.text = generation;
        bioTextView.text = bio;
    }
    
    
    
    
    
}
