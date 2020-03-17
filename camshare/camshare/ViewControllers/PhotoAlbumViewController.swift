//
//  PhotoAlbumViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/07.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import camPod
import FirebaseAuth

var selectedAlbumIndex: Int = 0

class PhotoAlbumViewController: ViewController {
    // MARK: OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    // MARK: Properties

    let albumViewModel = AlbumViewModel()
    let allUserAlbums = ShowingAllUserAlbumsViewModel()
    var userAlbumNames = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = allUserAlbums.getUserAlbumsArray { (array) in
            self.userAlbumNames = array
            print("Loaded Albums in PhotoAlbumViewController \(self.userAlbumNames)")
        }

        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style:
        //.plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                            target: self, action: #selector(logoutTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
        target: self, action: #selector(searchTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self, action: #selector(addTapped))

        // Do any additional setup after loading the view.
    }
    @objc func addTapped() {
        let alert = UIAlertController(title: "Add New Album", message: "Enter album name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "UI Test"//Auth.auth().currentUser?.uid
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let albumName = alert?.textFields![0].text
            self.allUserAlbums.addNewAlbum(newAlbumName: albumName!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func logoutTapped() {
        performSegue(withIdentifier: "Logout", sender: self)
    }
    @objc func searchTapped() {
        performSegue(withIdentifier: "Search", sender: self)
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
        return albumViewModel.getCount() // For implementation: userAlbumNAmes.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable all
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        //swiftlint:enable all
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(PhotoAlbumViewController.tap(_:)))
            cell.imageView.isUserInteractionEnabled = true
            cell.imageView.tag = indexPath.row
            cell.imageView.addGestureRecognizer(tapGestureRecognizer)
        let image = albumViewModel.getThumbnail(index: indexPath.item)//images[indexPath.item]
            cell.imageView.image = image
            return cell
        }

        @IBAction func tap(_ sender: AnyObject) {
            print("ViewController tap() Clicked Item: \(sender.view.tag)")
            selectedAlbumIndex = sender.view.tag
            performSegue(withIdentifier: "loadAlbum", sender: self)
//            selectedImageView.image = images[sender.view.tag]
        }
}
