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
import AVFoundation

var selectedAlbumIndex: Int = 0
public protocol albumSelectionProtocol {
    func didSelectAlbum(albumImages: [UIImage])
}

class PhotoAlbumViewController: ViewController, AVCaptureMetadataOutputObjectsDelegate {

    // MARK: OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: Properties
    var currentUser: camPod.User?
    var albums = [SingleAlbum]()
    var selectedIndex = 0
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let trackAnalytics = TrackFirebaseAnalytics()
    var isEditingAlbums: Bool = false
    var isCellSelected: Bool = false
    var selectedIndexForEditing = 0

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
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
//                                                            target: self, action: #selector(logoutTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
        target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self, action: #selector(editTapped))
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
                        self.albums.append(album) // MARK: Revise that album images does not download
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

    //swiftlint:disable all
    @objc func addTapped() {
        //swiftlint:enable all
        trackAnalytics.log(name: NameConstants.addAlbum, parameters: nil)
        let actionSheet = UIAlertController(title: "Add Album", message: "Choose an option",
                                            preferredStyle: .actionSheet)
        let createNewAction = UIAlertAction(title: "Create new", style: .default) { (_) in
            let alert = UIAlertController(title: "New Album", message: "Enter a name for this album",
                                          preferredStyle: .alert)
            self.trackAnalytics.log(name: NameConstants.createNewAlbum, parameters: nil)
            alert.addTextField { (textField) in
                textField.placeholder = "Title"//Auth.auth().currentUser?.uid
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                self.trackAnalytics.log(name: NameConstants.cancelCreateNew, parameters: nil)
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
                self.trackAnalytics.log(name: NameConstants.saveCreateNew, parameters: nil)
                let albumName = alert?.textFields![0].text
                //self.allUserAlbums.addNewAlbum(newAlbumName: albumName!)
                if let albumName = albumName {
                    self.albumViewModel.addNewAlbum(albumName: albumName) { (newAlbumAdded) in
                        self.albums.append(newAlbumAdded)
                        self.trackAnalytics.log(name: NameConstants.albumCreated, parameters: nil)
                        self.collectionView.reloadData()
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }

        let existingAlbumAction = UIAlertAction(title: "Existing Album", style: .default) { (_) in
            self.trackAnalytics.log(name: NameConstants.existingAlbum, parameters: nil)
            let alert = UIAlertController(title: "Existing Album", message: "Paste or type the album ID",
                                          preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Example: xHDJjdhhdy33b39KKJhdgwv"
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                self.trackAnalytics.log(name: NameConstants.cancelExisting, parameters: nil)
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert](_) in
                self.trackAnalytics.log(name: NameConstants.saveExisting, parameters: nil)
                let existingAlbumID = alert?.textFields![0].text
                if let existingAlbumID = existingAlbumID {
                    let newAlbumID = existingAlbumID
                    self.currentUser?.albumIDs.append(newAlbumID)
                    self.albumViewModel.updateUserAlbumIDs(newAlbumIDs: self.currentUser!.albumIDs)
                    self.albumViewModel.getExistingAlbumFromFirebase(albumID: newAlbumID) { (existingAlbum) in
                        self.albums.append(existingAlbum)
                        self.collectionView.reloadData()
                        self.trackAnalytics.log(name: NameConstants.albumAddedID, parameters: nil)
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }

        let scanQRCode = UIAlertAction(title: "Scan QR Code", style: .default) { (_) in
            self.trackAnalytics.log(name: NameConstants.scanQRCode, parameters: nil)
            self.captureQRCode()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.trackAnalytics.log(name: NameConstants.cancelAdd, parameters: nil)
        }

        actionSheet.addAction(createNewAction)
        actionSheet.addAction(scanQRCode)
        actionSheet.addAction(existingAlbumAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }

    @objc func editTapped() {
        self.collectionView.allowsSelection = true
        isEditingAlbums = true
        collectionView.reloadData()
    }

    @objc func logoutTapped() {
        //Auth.auth().signOut()
        performSegue(withIdentifier: "Logout", sender: self)
    }

    @objc func searchTapped() {
        performSegue(withIdentifier: "Search", sender: self)
    }

    func captureQRCode() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            captureSession.addInput(videoInput)
        } catch {
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)

        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr]

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        trackAnalytics.log(name: NameConstants.scanQRCode, parameters: nil)
    }

    func failed() {
        let alert = UIAlertController(title: "Scanning not supported", message: "Device Error", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        captureSession = nil
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            captureSession.stopRunning()
            previewLayer.removeFromSuperlayer()
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        //Add to user.albumID
        let newAlbumID = code
        currentUser?.albumIDs.append(newAlbumID)
        //save user new albumID
        albumViewModel.updateUserAlbumIDs(newAlbumIDs: currentUser!.albumIDs)
        //get album from album from firebase
        albumViewModel.getExistingAlbumFromFirebase(albumID: newAlbumID) { (existingAlbum) in
            self.albums.append(existingAlbum)
            self.collectionView.reloadData()
            self.trackAnalytics.log(name: NameConstants.albumAddedQR, parameters: nil)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    public func presentDeleteActionSheet() {
        let alert = UIAlertController(title: "Edit Album", message: "Choose an option", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            print("Being Deleted: \(self.currentUser?.albumIDs[self.selectedIndexForEditing])")
            self.albumViewModel.deleteAlbum(albumIDs: self.currentUser!.albumIDs,
                                            selectedAlbumIndex: self.selectedIndexForEditing) { (updatedAlbumIDs) in
                self.currentUser?.albumIDs = updatedAlbumIDs
                self.albums.remove(at: self.selectedIndexForEditing)
                self.collectionView.reloadData()
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(_) in
            self.isEditingAlbums = false
            self.isCellSelected = false
            self.collectionView.reloadData()
        }))
        present(alert, animated: true)
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

        let editTapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(PhotoAlbumViewController.selectToEdit(_:)))
        cell.imageView.isUserInteractionEnabled = true
        cell.imageView.tag = indexPath.row
        if isEditingAlbums {
            cell.imageView.addGestureRecognizer(editTapGesture)
            if self.isCellSelected {
                if cell.imageView.tag == selectedIndexForEditing {
                    cell.imageView.alpha = 1
                    print("Interrupt To Delete")
                    self.isCellSelected = false
                    self.presentDeleteActionSheet()
                }
            }

            if (isEditingAlbums) && !(isCellSelected) {
                cell.imageView.alpha = 0.5
            }
        } else {
            cell.imageView.alpha = 1
            cell.imageView.addGestureRecognizer(tapGestureRecognizer)
        }

        print("try to load albums")
        let image = albums[indexPath.item].thumbnail
        cell.imageView.image = image
        cell.albumNameLabel.text = albums[indexPath.item].name
        return cell
    }

    @IBAction func selectToEdit(_ sender: AnyObject) {
        selectedIndexForEditing = sender.view.tag
        isCellSelected = true
        collectionView.reloadData()
        print("Finished loading - Present popup")
    }

    @IBAction func tap(_ sender: AnyObject) {
        print("ViewController tap() Clicked Item: \(sender.view.tag)")
        self.selectedIndex = sender.view.tag
        performSegue(withIdentifier: "loadAlbum", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // MARK: OBJECTIVE C Controller
        //swiftlint:disable all
        if segue.identifier == "loadAlbum" {
            let singleAlbumViewControllerObjC = segue.destination as! SingleAlbumObjCViewController
            singleAlbumViewControllerObjC.albumID = self.albums[self.selectedIndex].albumID
            singleAlbumViewControllerObjC.imagePathReferences = self.albums[selectedIndex].imagePaths
            singleAlbumViewControllerObjC.albumName = self.albums[selectedIndex].name
        } else {
            print("Other segue runs")
        }
        //swiftlint:enable all
    }
}
