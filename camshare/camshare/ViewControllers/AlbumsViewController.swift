//
//  AlbumsViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/27.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import camPod

class AlbumsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let albumViewModel = AlbumViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cameraBarItemTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false //can crop if true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension AlbumsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
}

extension AlbumsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10//albumViewModel.getCount() //Users.albums.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable all
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        //swiftlint:enable all

        //let image = UIImage(named: "placeholder")//albumViewModel.getThumbnail(index: indexPath.item)

        //cell.imageView.image = image
        return cell
    }
}
