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

    //let loginViewModel = UserSignUpLoginViewModel()
    lazy var userViewModel: UserSignUpLoginViewModel = {
        return UserSignUpLoginViewModel(repo: UserModel())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        customizeButtons()

        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        // Do any additional setup after loading the view.
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

        // MARK: NEW Model Login
        // MARK: Revise - no need to send back user, user is fetched somwhere else
        userViewModel.login(with: email, and: password) { (success, error, _) in //user is sent back from closure
            if success {
                self.transitionToHome()
            } else {
                DispatchQueue.main.async { // Correct
                    self.errorLabel.text = error
                    self.errorLabel.alpha = 1
                }
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
