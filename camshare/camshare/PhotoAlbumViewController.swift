//
//  PhotoAlbumViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/07.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit

var selectedImageIndex: Int = 0

class PhotoAlbumViewController: ViewController {
    // MARK: OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedImageView: UIImageView!

    // MARK: Properties

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
// MARK: Flow layout delegate

extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 3
        let width = collectionView.frame.size.width
        let xInsets: CGFloat = 5
        let cellSpacing: CGFloat = 10
        return CGSize(width: (width/numberOfColumns) - (xInsets + cellSpacing), height: (width/numberOfColumns) -
            (xInsets + cellSpacing))
    }
}

// MARK: DATASOURCE
extension PhotoAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable all
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        //swiftlint:enable all
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(PhotoAlbumViewController.tap(_:)))
            cell.imageView.isUserInteractionEnabled = true
            cell.imageView.tag = indexPath.row
            cell.imageView.addGestureRecognizer(tapGestureRecognizer)
            let image = images[indexPath.item]
            cell.imageView.image = image
            return cell
        }

        @IBAction func tap(_ sender: AnyObject) {
            print("ViewController tap() Clicked Item: \(sender.view.tag)")
            selectedImageIndex = sender.view.tag
            performSegue(withIdentifier: "loadPhoto", sender: self)
//            selectedImageView.image = images[sender.view.tag]
        }
}
