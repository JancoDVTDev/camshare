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
public protocol albumSelectionProtocol {
    func didSelectAlbum(albumImages: [UIImage])
}

class PhotoAlbumViewController: ViewController {

    // MARK: OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: Properties
    var currentUser: camPod.User?
    var albums = [SingleAlbum]()
    var albumSelectedDelegate: albumSelectionProtocol!
    var selectedIndex = 0

    //var userAlbum = [UIImage]()
    var userAlbums = [[UIImage]]()
    var isNewUser = true

    var albumViewModel = AlbumViewModel()
    let allUserAlbums = ShowingAllUserAlbumsViewModel()
    var userAlbumNames = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style:
        //.plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                            target: self, action: #selector(logoutTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
        target: self, action: #selector(searchTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self, action: #selector(addTapped))
        reloadAlbums { (success) in
            if success {
                self.collectionView.reloadData()
            }
        }
    }

    func reloadAlbums(_ completion: @escaping (_ success: Bool) -> Void) {
        var count = 0
        albumViewModel.getUserData { (_, isNewUser, user) in
            self.currentUser = user
            print("Current user signed in: \(Auth.auth().currentUser?.uid ?? "")")
            print("Details: \(user.albumIDs) user new \(isNewUser)")
            if !(isNewUser) {
                for albumID in user.albumIDs {
                    count += 1
                    self.albumViewModel.getAlbumNew(albumID: albumID) { (album) in
                        self.albums.append(album)
                        print("Number of albums \(self.albums.count)")
                        print(self.albums)
                        if (user.albumIDs.count) == count {
                            completion(true)
                        }
                    }
                }
            }
        }
    }

    @objc func addTapped() {
        let alert = UIAlertController(title: "Add New Album", message: "Enter album name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "UI Test"//Auth.auth().currentUser?.uid
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let albumName = alert?.textFields![0].text
            //self.allUserAlbums.addNewAlbum(newAlbumName: albumName!)
            if let albumName = albumName {
                self.albumViewModel.addNewAlbum(albumName: albumName) { (_) in //newAlbum is sent back from completion
                    print("Album succesfully added - View should now update")
                    self.reloadAlbums { (success) in
                        if success {
                            self.collectionView.collectionViewLayout.invalidateLayout()
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
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
        return albums.count//albumViewModel.getCount()//userAlbums.count// For implementation: userAlbumNAmes.count
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

        //let image = dummyAlbum[indexPath.item]
        //let image = albumViewModel.getThumbnail(index: indexPath.item)//images[indexPath.item]
        print("try to load albums")
        let image = albums[indexPath.item].thumbnail//userAlbums[indexPath.item][0]
        //let image = UIImage(named: "placeholder")!
        cell.imageView.image = image
        return cell
    }

    @IBAction func tap(_ sender: AnyObject) {
        print("ViewController tap() Clicked Item: \(sender.view.tag)")
//        selectedAlbumIndex = sender.view.tag
//        selectedImageView.image = images[sender.view.tag]
        self.selectedIndex = sender.view.tag

        // MARK: SEGUE
//        let singleAlbum = (storyboard?.instantiateViewController(identifier: "SingleAlbumView"))! as SingleAlbumViewController
//        singleAlbum.imagePathReferences = albums[selectedIndex].imagePaths
//        present(singleAlbum, animated: true, completion: nil)
        // MARK: Using Notification Centre
//        let name = Notification.Name(rawValue: "didSelectAlbum")
//        let images = albums[selectedIndex].images
//        NotificationCenter.default.post(name: name, object: nil, userInfo: ["images": images])
        // MARK: Using Protocol - issue: albumSelectedDelegate is not initialised
//        let images: [UIImage] = albums[selectedIndex].images
//        let singleView = (storyboard?.instantiateViewController(identifier: "SingleAlbumView"))!
//            as SingleAlbumViewController
//        //albumSelectedDelegate = singleView
//        if selectedIndex == 0 {
//            performSegue(withIdentifier: "loadAlbum", sender: self)
//        } else {
//            dismiss(animated: true, completion: nil)
//            albumSelectedDelegate.didSelectAlbum(albumImages: images)
//        }
        performSegue(withIdentifier: "loadAlbum", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //swiftlint:disable all
//        let singleAlbumViewController = segue.destination as! SingleAlbumViewController
//        //swiftlint:enable all
//        singleAlbumViewController.imagePathReferences = self.albums[self.selectedIndex].imagePaths
//        singleAlbumViewController.currentAlbumID = self.albums[self.selectedIndex].albumID
//        print(self.albums[selectedIndex].albumID)

        // MARK: OBJECTIVE C

        //swiftlint:disable all
        let singleAlbumViewControllerObjC = segue.destination as! SingleAlbumObjCViewController
        singleAlbumViewControllerObjC.albumID = self.albums[self.selectedIndex].albumID
        singleAlbumViewControllerObjC.imagePathReferences = self.albums[selectedIndex].imagePaths
        singleAlbumViewControllerObjC.albumName = self.albums[selectedIndex].name
        //swiftlint:enable all
    }
}
