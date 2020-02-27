//
//  SelectedAlbumViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/27.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import camPod

class SelectedAlbumViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    let modelView: CameraBehaviour! = nil //initialize with current user maybe

    @IBAction func cameraBarItemTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false //can crop if true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let takenPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            modelView.savePicture(file: takenPhoto)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
