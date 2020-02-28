//
//  SingleAlbumViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/28.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import camPod

var selectedImageIndex: Int = 0

class SingleAlbumViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var myCollectionView: UICollectionView!
    let albumViewModel = AlbumViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera,
                                                            target: self, action: #selector(cameraTapped))
        // Do any additional setup after loading the view.
    }

    @objc func cameraTapped() {
        //performSegue(withIdentifier: "goToCamera", sender: self)
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
            //albumViewModel.appendToAlbum(albumIndex: selectedAlbumIndex, image: takenPhoto)

        }
        picker.dismiss(animated: true, completion: nil)
    }

}

// MARK: Flow layout delegate

extension SingleAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 5
        let width = myCollectionView.frame.size.width
        let xInsets: CGFloat = 5
        let cellSpacing: CGFloat = 10
        return CGSize(width: (width/numberOfColumns) - (xInsets + cellSpacing), height: (width/numberOfColumns) -
            (xInsets + cellSpacing))
    }
}

// MARK: DATASOURCE

extension SingleAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumViewModel.getAlbumSize(index: selectedAlbumIndex)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable all
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        //swiftlint: enable all
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(SingleAlbumViewController.imageTapped(_:)))
        cell.imageView.isUserInteractionEnabled = true
        cell.imageView.tag = indexPath.row
        cell.imageView.addGestureRecognizer(tapGestureRecognizer)
        let image = albumViewModel.getSingleImage(selectedAlbum: selectedAlbumIndex, index: indexPath.item)
        cell.imageView.image = image
        return cell
    }
    
    @IBAction func imageTapped(_ sender: AnyObject) {
        selectedImageIndex = sender.view.tag
        performSegue(withIdentifier: "loadPhoto", sender: self)
    }
    
}
