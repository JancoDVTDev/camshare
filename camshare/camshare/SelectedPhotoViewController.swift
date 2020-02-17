//
//  SelectedPhotoViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/15.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit

class SelectedPhotoViewController: UIViewController {

    @IBOutlet weak var selectedPhotoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPhotoImageView.image = images[selectedImageIndex]
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
