//
//  CameraViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/26.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var takenPhoto: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let availableImage = takenPhoto {
            imageView.image = availableImage
        }
    }

    @IBAction func goBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
