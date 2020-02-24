//
//  SignUpViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/18.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FuncLibrary

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

    @IBAction func signUpButtonTapped(_ sender: Any) {
            //Validate Fields
            let error = validateFields()

            if error != nil {
                showError(error!)
            } else {
                //Create cleaned versions of the data
                let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                //Create User
                Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                    //check for errors
                    if err != nil {
                        //There was error creating the user
                        self.showError("Error creating user")
                    } else {
                        //User was created succesfull
                        let firebaseDb = Firestore.firestore()
                        firebaseDb.collection("users").addDocument(data: [
                            "firstName": firstName,
                            "lastName": lastName,
                            "uid": result!.user.uid]) { (errOne) in
                            if errOne != nil {
                                self.showError("User couldn't be saved")
                            }
                        }
                        // Transition to the home screen
                        self.transitionToHome()
                    }
                }
            }
        }

        func validateFields() -> String? {
            // if everything is good return nil, else return error message for errorlabel
            if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  == "" ||
                lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  == "" ||
                emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return "Please fill in all fields"
            }

            let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            if FrameWorkUtilities.isPasswordValid(cleanedPassword) {
//                return "Please make sure your password is at least 8 characters"
//            }

            if  Utilities.isPasswordValid(cleanedPassword) == false {
                return "Please make sure your password is at least 8 characters"
            }
            return nil
        }
        func showError(_ message: String) {
            errorLabel.text = message
            errorLabel.alpha = 1
        }

        func transitionToHome() {
            let photoAlbumViewController = storyboard?.instantiateViewController(identifier:
                Constants.Storyboard.homeViewController) as? UINavigationController
            view.window?.rootViewController = photoAlbumViewController
            view.window?.makeKeyAndVisible()
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
        styleButton(button: facebookSignUp, colorOne: Colors.csFacebook,
                                       colorTwo: Colors.csLighFacebook)
        styleButton(button: gmailSignUp, colorOne: Colors.csGoogle, colorTwo: Colors.csLightGoogle)
    }
}
