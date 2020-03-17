//
//  SelectedPhotoViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/15.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import camPod

class SelectedPhotoViewController: UIViewController {

    @IBOutlet weak var selectedPhotoImageView: UIImageView!

    let albumViewModel = AlbumViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPhotoImageView.image = albumViewModel.getSingleImage(selectedAlbum: selectedAlbumIndex,
                                                                     index: selectedImageIndex)
    }
}
