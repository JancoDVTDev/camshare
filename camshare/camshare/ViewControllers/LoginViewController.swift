//
//  LoginViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/18.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import Firebase
import camPod

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var acitivityIndicator: UIActivityIndicatorView!

    //let loginViewModel = UserSignUpLoginViewModel()
    let loginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel.view = self // inject property
        loginViewModel.repo = LoginDataSource() // inject property
        errorLabel.alpha = 0
        acitivityIndicator.isHidden = true
        customizeButtons()
    }

    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        // Validate Text Fields
        Analytics.logEvent("login_pressed", parameters: nil)
        // Create clean versions of textFields
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        acitivityIndicator.startAnimating()
        acitivityIndicator.isHidden = false
        loginViewModel.login(email: email, password: password)
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
        DispatchQueue.main.async {
            let photoAlbumViewController = self.storyboard?.instantiateViewController(identifier:
                Constants.Storyboard.homeViewController) as? UINavigationController
            self.view.window?.rootViewController = photoAlbumViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
}
extension LoginViewController: LoginViewProtocol {
    func readyForNavigation() {
        acitivityIndicator.stopAnimating()
        acitivityIndicator.isHidden = true
    }

    func navigateToAlbumsScreen() {
        print("Navigate Now")
        transitionToHome()
    }

    func displayError(error: String) {
        errorLabel.text = error
        errorLabel.alpha = 1
        acitivityIndicator.stopAnimating()
        acitivityIndicator.isHidden = true
    }
}
