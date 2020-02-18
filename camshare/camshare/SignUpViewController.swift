//
//  SignUpViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/18.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var facebookSignUp: UIButton!
    @IBOutlet weak var gmailSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        customizeButtons()
        // Do any additional setup after loading the view.
    }
    
    func styleButton(button: UIButton?, colorOne: UIColor, colorTwo: UIColor) {
        if let button = button {
            button.layer.cornerRadius = button.frame.size.height/2
            button.layer.masksToBounds = true
            button.setTitleColor(UIColor.white, for: .normal)
            button.setGradientBackground(colorOne: colorOne, colorTwo: colorTwo)
        }
    }

    func customizeButtons() {
        styleButton(button: signUpButton, colorOne: Colors.csBlue, colorTwo: Colors.csLightBlue)
        styleButton(button: facebookSignUp, colorOne: Colors.csFacebook, colorTwo: Colors.csLighFacebook)
        styleButton(button: gmailSignUp, colorOne: Colors.csGoogle, colorTwo: Colors.csLightGoogle)
    }
}
