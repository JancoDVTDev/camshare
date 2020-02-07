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
    
    //MARK: CREATE ACCOUNT VIEW OBJECT CONSTRAINTS
    @IBOutlet weak var loginButtonCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var createAccountButtonCenterConstraint: NSLayoutConstraint!
    
    //MARK: CREATE ACCOUNT VIEW OBJECTS
    @IBOutlet weak var createAccountUsingLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var alreadyHaveAnAccountButton: UIButton!
    
    //MARK: CREATE ACCOUNT VIEW OBJECT CONSTRAINTS
    @IBOutlet weak var faceBookButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var instagramButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var googleButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var alreadyHaveAnAccountTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        faceBookButtonTopConstraint.constant += view.bounds.height
        googleButtonTopConstraint.constant += view.bounds.height
        instagramButtonTopConstraint.constant += view.bounds.height
        googleButtonTopConstraint.constant += view.bounds.height
        alreadyHaveAnAccountTopConstraint.constant += view.bounds.height
        customizeButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginButtonCenterConstraint.constant -= view.bounds.width
        createAccountButtonCenterConstraint.constant += view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginButtonCenterConstraint.constant = 0
        createAccountButtonCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations:{ [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: BUTTON CLICKED EVENTS
    @IBAction func alreadyhaveanAccountButtonClicked(_ sender: Any) {
        faceBookButtonTopConstraint.constant += view.bounds.height
        googleButtonTopConstraint.constant += view.bounds.height
        instagramButtonTopConstraint.constant += view.bounds.height
        googleButtonTopConstraint.constant += view.bounds.height
        alreadyHaveAnAccountTopConstraint.constant += view.bounds.height
        loginButtonCenterConstraint.constant -= view.bounds.width
        createAccountButtonCenterConstraint.constant += view.bounds.width
        prepareAlreadyHaveAccount()
    }
    

    @IBAction func createAccountButtonClicked(_ sender: Any) {
        prepareCreateAccount()
    }
    
    //MARK: FUNCTIONS
    
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
        
        faceBookButtonTopConstraint.constant = 121
        UIView.animate(withDuration: 1) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        instagramButtonTopConstraint.constant = 8
        UIView.animate(withDuration: 0.5,
                        delay: 0.3,
                        options: [],
                        animations: { [weak self] in
                        self?.view.layoutIfNeeded()
        }, completion: nil)
        
        googleButtonTopConstraint.constant = 8
            UIView.animate(withDuration: 0.5,
                            delay: 0.3,
                            options: [],
                            animations: { [weak self] in
                            self?.view.layoutIfNeeded()
            }, completion: nil)
        
        emailButtonTopConstraint.constant = 8
            UIView.animate(withDuration: 0.5,
                            delay: 0.3,
                            options: [],
                            animations: { [weak self] in
                            self?.view.layoutIfNeeded()
                }, completion: nil)
        
        alreadyHaveAnAccountTopConstraint.constant = 8
        UIView.animate(withDuration: 0.5,
                        delay: 0.3,
                        options: [],
                        animations: { [weak self] in
                        self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func prepareAlreadyHaveAccount(){
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
    
    func customizeButton(){
        loginButton.layer.cornerRadius = loginButton.frame.size.height/2
        loginButton.layer.masksToBounds = true
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.setGradientBackground(colorOne: Colors.csBlue, colorTwo: Colors.csLightBlue)
        
        createAccountButton.layer.cornerRadius = loginButton.frame.size.height/2
        createAccountButton.layer.masksToBounds = true
        createAccountButton.setTitleColor(UIColor.white, for: .normal)
        createAccountButton.setGradientBackground(colorOne: Colors.csBlue, colorTwo: Colors.csLightBlue)
        
        facebookButton.layer.cornerRadius = facebookButton.frame.size.height/2
        facebookButton.layer.masksToBounds = true
        facebookButton.setTitleColor(UIColor.white, for: .normal)
        facebookButton.setGradientBackground(colorOne: Colors.csFacebook, colorTwo: Colors.csLighFacebook)
        
        instagramButton.layer.cornerRadius = facebookButton.frame.size.height/2
        instagramButton.layer.masksToBounds = true
        instagramButton.setTitleColor(UIColor.white, for: .normal)
        instagramButton.setGradientBackground(colorOne: Colors.csInstagram, colorTwo: Colors.csInstagramLight)
        
        googleButton.layer.cornerRadius = googleButton.frame.size.height/2
        googleButton.layer.masksToBounds = true
        googleButton.setTitleColor(UIColor.white, for: .normal)
        googleButton.setGradientBackground(colorOne: Colors.csGoogle, colorTwo: Colors.csLightGoogle)
        
        emailButton.layer.cornerRadius = emailButton.frame.size.height/2
        emailButton.layer.masksToBounds = true
        emailButton.setTitleColor(UIColor.white, for: .normal)
        emailButton.setGradientBackground(colorOne: Colors.csBlack, colorTwo: Colors.csGrey)
    }
    
}

