//
//  StartUpViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/18.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import FirebaseAuth

class StartUpViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        isUserLoggedIn()
        customizeButtons()
        // Do any additional setup after loading the view.
    }

    func isUserLoggedIn() {
        if Auth.auth().currentUser?.uid != nil {
            transitionToHome()
        }
    }

    func transitionToHome() {
        DispatchQueue.main.async {
            let photoAlbumViewController = self.storyboard?.instantiateViewController(identifier:
                Constants.Storyboard.homeViewController) as? UINavigationController
            self.view.window?.rootViewController = photoAlbumViewController
            self.view.window?.makeKeyAndVisible()
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
        styleButton(button: loginButton, colorOne: Colors.csBlue, colorTwo: Colors.csLightBlue)
    }

}
