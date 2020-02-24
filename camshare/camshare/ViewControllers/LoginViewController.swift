//
//  LoginViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/18.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        customizeButtons()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        // Validate Text Fields

        // Create clean versions of textFields
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (_, err) in //result
            if err != nil {
                self.errorLabel.text = err?.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                //User signed in succesfully
                self.transitionToHome()
            }
        }
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
        styleButton(button: loginButton, colorOne: Colors.csBlue, colorTwo: Colors.csLightBlue)
    }

    func transitionToHome() {
        let photoAlbumViewController = storyboard?.instantiateViewController(identifier:
            Constants.Storyboard.homeViewController) as? UINavigationController
        view.window?.rootViewController = photoAlbumViewController
        view.window?.makeKeyAndVisible()
    }

}
