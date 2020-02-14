//
//  PhotoAlbumViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/07.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: ViewController {
    // MARK: OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedImageView: UIImageView!

    // MARK: Properties
    var images = [UIImage(named: "image-1"), UIImage(named: "Image2"), UIImage(named: "Image3"),
    UIImage(named: "Image4"), UIImage(named: "Image5"), UIImage(named: "Image6"),
    UIImage(named: "Image7"), UIImage(named: "Image8"), UIImage(named: "Image9"),
    UIImage(named: "Image10"), UIImage(named: "Image11"), UIImage(named: "Image12")]

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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PhotoAlbumViewController.tap(_:)))
            cell.imageView.isUserInteractionEnabled = true
            cell.imageView.tag = indexPath.row
            cell.imageView.addGestureRecognizer(tapGestureRecognizer)
            let image = images[indexPath.item]
            cell.imageView.image = image
            return cell
        }
        
        @IBAction func tap(_ sender:AnyObject){
            print("ViewController tap() Clicked Item: \(sender.view.tag)")
            selectedImageView.image = images[sender.view.tag]
        }
}
