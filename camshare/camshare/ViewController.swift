//
//  ViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/07.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: LOGIN VIEW OBJECTS
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    // MARK: CREATE ACCOUNT VIEW OBJECT CONSTRAINTS
    @IBOutlet weak var loginButtonCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var createAccountButtonCenterConstraint: NSLayoutConstraint!
    // MARK: CREATE ACCOUNT VIEW OBJECTS
    @IBOutlet weak var createAccountUsingLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var alreadyHaveAnAccountButton: UIButton!
    // MARK: CREATE ACCOUNT VIEW OBJECT CONSTRAINTS
    @IBOutlet weak var faceBookButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var instagramButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var googleButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var alreadyHaveAnAccountTopConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let fbConstraint = faceBookButtonTopConstraint {
            fbConstraint.constant += view.bounds.height
        }
        if let gConstraint = googleButtonTopConstraint {
            gConstraint.constant += view.bounds.height
        }
        if let instContraint = instagramButtonTopConstraint {
            instContraint.constant += view.bounds.height
        }
        if let eContraint = emailButtonTopConstraint {
            eContraint.constant += view.bounds.height
        }
        if let alreadyConstraint = alreadyHaveAnAccountTopConstraint {
            alreadyConstraint.constant += view.bounds.height
        }
        customizeButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let loginContraint = loginButtonCenterConstraint {
            loginContraint.constant -= view.bounds.width
        }

        if let createContraint = createAccountButtonCenterConstraint {
            createContraint.constant += view.bounds.width
        }

        // MARK: 111 Changes
//        loginButtonCenterConstraint.constant -= view.bounds.width
//        createAccountButtonCenterConstraint.constant += view.bounds.width
    }
    override func viewDidAppear(_ animated: Bool) {
        // MARK: 111 Changes
        if let lgButton = loginButtonCenterConstraint {
            lgButton.constant = 0
        }

        if let crButton = createAccountButtonCenterConstraint {
            crButton.constant = 0
        }
//        loginButtonCenterConstraint.constant = 0
//        createAccountButtonCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    // MARK: BUTTON CLICKED EVENTS
    @IBAction func alreadyhaveanAccountButtonClicked(_ sender: Any) {
        if let faceBookButtonTopConstraint = faceBookButtonTopConstraint {
            faceBookButtonTopConstraint.constant += view.bounds.height
        }
        if let googleButtonTopConstraint = googleButtonTopConstraint {
            googleButtonTopConstraint.constant += view.bounds.height
        }
        if let instagramButtonTopConstraint = instagramButtonTopConstraint {
            instagramButtonTopConstraint.constant += view.bounds.height
        }
        if let emailButtonTopConstraint = emailButtonTopConstraint {
            emailButtonTopConstraint.constant += view.bounds.height
        }
        if let alreadyHaveAnAccountTopConstraint = alreadyHaveAnAccountTopConstraint {
            alreadyHaveAnAccountTopConstraint.constant += view.bounds.height
        }
        loginButtonCenterConstraint.constant -= view.bounds.width
        createAccountButtonCenterConstraint.constant += view.bounds.width
        prepareAlreadyHaveAccount()
    }

    @IBAction func createAccountButtonClicked(_ sender: Any) {
        prepareCreateAccount()
    }

    @IBAction func albumButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "goToAlbum", sender: self)
    }

    // MARK: FUNCTIONS
    func prepareCreateAccount() {
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        loginButton.isHidden = true
        createAccountButton.isHidden = true
        orLabel.isHidden = true
        createAccountUsingLabel.isHidden = false
        facebookButton.isHidden = false
        instagramButton.isHidden = false
        googleButton.isHidden = false
        emailButton.isHidden = false
        alreadyHaveAnAccountButton.isHidden = false
        let duration = 0.8
        faceBookButtonTopConstraint!.constant = 121
        UIView.animate(withDuration: duration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        instagramButtonTopConstraint.constant = 8
        UIView.animate(withDuration: duration,
                       delay: 0.3,
                        options: [],
                        animations: { [weak self] in
                        self?.view.layoutIfNeeded()
        }, completion: nil)

        googleButtonTopConstraint.constant = 8
            UIView.animate(withDuration: duration, delay: 0.6, options: [], animations: { [weak self] in
                            self?.view.layoutIfNeeded()
            }, completion: nil)

        emailButtonTopConstraint.constant = 8
            UIView.animate(withDuration: duration, delay: 0.9, options: [], animations: { [weak self] in
                            self?.view.layoutIfNeeded()
                }, completion: nil)

        alreadyHaveAnAccountTopConstraint.constant = 8
        UIView.animate(withDuration: duration,
                       delay: 1.2,
                        options: [],
                        animations: { [weak self] in
                        self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    func prepareAlreadyHaveAccount() {
        emailTextField.isHidden = false
        passwordTextField.isHidden = false
        loginButton.isHidden = false
        createAccountButton.isHidden = false
        orLabel.isHidden = false

        createAccountUsingLabel.isHidden = true
        facebookButton.isHidden = true
        instagramButton.isHidden = true
        googleButton.isHidden = true
        emailButton.isHidden = true
        alreadyHaveAnAccountButton.isHidden = true

        loginButtonCenterConstraint.constant = 0
        createAccountButtonCenterConstraint.constant = 0
        UIView.animate(withDuration: 1) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    func paintButton(button: UIButton?, colorOne: UIColor, colorTwo: UIColor) {
        if let button = button {
            button.layer.cornerRadius = button.frame.size.height/2
            button.layer.masksToBounds = true
            button.setTitleColor(UIColor.white, for: .normal)
            button.setGradientBackground(colorOne: colorOne, colorTwo: colorTwo)
        }
    }

    func customizeButton() {
        paintButton(button: loginButton, colorOne: Colors.csBlue, colorTwo: Colors.csLightBlue)
        paintButton(button: createAccountButton, colorOne: Colors.csBlue, colorTwo: Colors.csLightBlue)
        paintButton(button: facebookButton, colorOne: Colors.csFacebook, colorTwo: Colors.csLighFacebook)
        paintButton(button: instagramButton, colorOne: Colors.csInstagram, colorTwo: Colors.csInstagramLight)
        paintButton(button: googleButton, colorOne: Colors.csGoogle, colorTwo: Colors.csLightGoogle)
        paintButton(button: emailButton, colorOne: Colors.csBlack, colorTwo: Colors.csGrey)
//        if let loginButton = loginButton {
//            loginButton.layer.cornerRadius = loginButton.frame.size.height/2
//            loginButton.layer.masksToBounds = true
//            loginButton.setTitleColor(UIColor.white, for: .normal)
//            loginButton.setGradientBackground(colorOne: Colors.csBlue, colorTwo: Colors.csLightBlue)
//        }
    }
}
