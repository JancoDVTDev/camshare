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
import camPod

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var acitivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var facebookSignUp: UIButton!
    @IBOutlet weak var gmailSignUp: UIButton!

    let signUpViewModel = SignUpViewModel()
    var textFieldsCollection = [UITextField]()
    var originalY = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapOnView = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapOnView)
        errorLabel.alpha = 0
        customizeButtons()
        acitivityIndicator.isHidden = true

        signUpViewModel.repo = SignUpDataSource()
        signUpViewModel.view = self

        textFieldsCollection = [firstNameTextField, lastNameTextField,
                                emailTextField, passwordTextField]

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardsWillChange(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardsWillChange(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardsWillChange(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        let validPassword = signUpViewModel.validateFields(firstName: firstName, lastName: lastName,
                                                           email: email, password: password)
        if validPassword {
            signUpViewModel.signUp(firstName: firstName, lastName: lastName, email: email, password: password)
        }
    }

    func transitionToHome() {
        let photoAlbumViewController = storyboard?.instantiateViewController(identifier:
            Constants.Storyboard.homeViewController) as? UINavigationController
        view.window?.rootViewController = photoAlbumViewController
        view.window?.makeKeyAndVisible()
    }

    @objc func dismissKeyboard() {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    @objc func keyboardsWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue)?.cgRectValue else {return}

        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height + 110
        } else {
            view.frame.origin.y = 0
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
        styleButton(button: signUpButton, colorOne: Colors.csBlue, colorTwo: Colors.csLightBlue)
        styleButton(button: facebookSignUp, colorOne: Colors.csFacebook,
                    colorTwo: Colors.csLighFacebook)
        styleButton(button: gmailSignUp, colorOne: Colors.csGoogle, colorTwo: Colors.csLightGoogle)
    }
}
extension SignUpViewController: SignUpViewProtocol {
    func readyForNavigation() {
        acitivityIndicator.stopAnimating()
        acitivityIndicator.isHidden = true
        errorLabel.alpha = 0
    }

    func navigateToAlbumsScreen() {
        transitionToHome()
    }

    func displayError(error: String) {
        acitivityIndicator.stopAnimating()
        acitivityIndicator.isHidden = true
        errorLabel.text = error
        errorLabel.alpha = 1
    }
}
