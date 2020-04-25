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
import CoreImage
import WatchConnectivity

var selectedAlbumIndex: Int = 0
public protocol albumSelectionProtocol {
    func didSelectAlbum(albumImages: [UIImage])
}

class PhotoAlbumViewController: ViewController, AVCaptureMetadataOutputObjectsDelegate, WCSessionDelegate {

    // MARK: OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: New Properties MVP and Protocols
    var albumsCollectionViewSource = [SingleAlbum]()
    var userAlbumIDs = [String]()
    var session: WCSession?
    var watchData = [String: String]()
    var qrCodes = [Data]()

    let albumViewModel = AlbumViewModel()

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

    var userAlbums = [[UIImage]]()
    var isNewUser = true

    var albumViewModelOLD = AlbumViewModelOLD()
    let allUserAlbums = ShowingAllUserAlbumsViewModel()
    var userAlbumNames = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        collectionView.isHidden = true

        albumViewModel.view = self
        albumViewModel.repo = AlbumDataSource()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
        target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self, action: #selector(editTapped))
        configureWatchKitSession()
        albumViewModel.loadAlbums()
    }

    func configureWatchKitSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    //swiftlint:disable all
    @objc func addTapped() {
        //swiftlint:enable all
        trackAnalytics.log(name: NameConstants.addAlbum, parameters: nil)
        let actionSheet = UIAlertController(title: "Add Album", message: "Choose an option",
                                            preferredStyle: .actionSheet)
        let createNewAction = UIAlertAction(title: "Create New", style: .default) { (_) in
            let alert = UIAlertController(title: "New Album", message: "Enter a name for this album",
                                          preferredStyle: .alert)
            self.trackAnalytics.log(name: NameConstants.createNewAlbum, parameters: nil)
            alert.addTextField { (textField) in
                textField.placeholder = "Title"
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
                    self.albumViewModel.createNewAlbum(albumName: albumName,
                                                       albumIDs: self.userAlbumIDs,
                                                       currentAlbums: self.albumsCollectionViewSource)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }

        let existingAlbumAction = UIAlertAction(title: "Existing Album", style: .default) { (_) in
            self.trackAnalytics.log(name: NameConstants.existingAlbum, parameters: nil)
            let alert = UIAlertController(title: "Existing Album", message: "Paste or type the album ID",
                                          preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Album ID"
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                self.trackAnalytics.log(name: NameConstants.cancelExisting, parameters: nil)
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert](_) in
                self.trackAnalytics.log(name: NameConstants.saveExisting, parameters: nil)
                let existingAlbumID = alert?.textFields![0].text
                if let existingAlbumID = existingAlbumID {
                    self.albumViewModel.addExisting(albumID: existingAlbumID, albumIDs: self.userAlbumIDs,
                                                    currentAlbums: self.albumsCollectionViewSource)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }

        let scanQRCode = UIAlertAction(title: "Scan QR Code", style: .default) { (_) in
            self.trackAnalytics.log(name: NameConstants.scanQRCode, parameters: nil)
            self.captureQRCode()
        }

        let signOut = UIAlertAction(title: "Sign Out", style: .destructive) { (_) in
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error Signing out")
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.trackAnalytics.log(name: NameConstants.cancelAdd, parameters: nil)
        }

        actionSheet.addAction(createNewAction)
        actionSheet.addAction(scanQRCode)
        actionSheet.addAction(existingAlbumAction)
        actionSheet.addAction(signOut)
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
        self.albumViewModel.addExisting(albumID: newAlbumID, albumIDs: self.userAlbumIDs,
                                        currentAlbums: albumsCollectionViewSource)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
        //ChangeGIT
    }

    public func presentDeleteActionSheet() {
        let alert = UIAlertController(title: "Edit Album", message: "Choose an option", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            print("Being Deleted: \(String(describing: self.currentUser?.albumIDs[self.selectedIndexForEditing]))")
            self.albumViewModelOLD.deleteAlbum(albumIDs: self.currentUser!.albumIDs,
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

    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        // call refreshFunction
    }

    func populateWatchDataDictionary() {
        for album in albumsCollectionViewSource {
            guard let qrImage = generateQRCode(from: album.albumID) else {return}
            qrCodes.append(qrImage.jpegData(compressionQuality: 1)!)
            watchData[album.name] = album.dateCreated
        }
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
        return albumsCollectionViewSource.count
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
        let image = albumsCollectionViewSource[indexPath.item].thumbnail
        cell.imageView.image = image
        cell.albumNameLabel.text = albumsCollectionViewSource[indexPath.item].name
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
            let photosViewController = segue.destination as! PhotosViewController
            photosViewController.albumID = self.albumsCollectionViewSource[self.selectedIndex].albumID
            photosViewController.userImagePaths = self.albumsCollectionViewSource[self.selectedIndex].imagePaths
            photosViewController.albumName = self.albumsCollectionViewSource[self.selectedIndex].name
//            let singleAlbumViewControllerObjC = segue.destination as! SingleAlbumObjCViewController
//            singleAlbumViewControllerObjC.albumID = self.albums[self.selectedIndex].albumID
//            singleAlbumViewControllerObjC.imagePathReferences = self.albums[selectedIndex].imagePaths
//            singleAlbumViewControllerObjC.albumName = self.albums[selectedIndex].name
        } else {
            print("Other segue runs")
        }
        //swiftlint:enable all
    }

    func loadSavedImages(imagePaths: [String],
                         _ completion: @escaping (_ cachedPhotoModels: [PhotoModel],
        _ imagePathsToUpdate: [String]) -> Void) {

    }
}
extension PhotoAlbumViewController: AlbumViewProtocol {
    func updateAlbumCollectionViewSource(singleAlbums: [SingleAlbum]) {
        albumsCollectionViewSource = singleAlbums
    }

    func updateUserAlbumIDs(albumIDs: [String]) {
        userAlbumIDs = albumIDs
    }

    func setAlbumCollectionViewSource(singleAlbums: [SingleAlbum]) {
        albumsCollectionViewSource = singleAlbums
        populateWatchDataDictionary()
        if let validSession = self.session, validSession.isReachable {
            let data = ["Albums": watchData]
            validSession.sendMessage(data, replyHandler: nil, errorHandler: nil)
        } else {
            print("Session not working")
        }

        if let validSession = self.session, validSession.isReachable {
            let data = ["ImageCodes": qrCodes]
            validSession.sendMessage(data, replyHandler: nil, errorHandler: nil)
        }
    }

    func didFinishLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        activityLabel.alpha = 0
        collectionView.reloadData()
        collectionView.isHidden = false
    }

    func displayError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func updateAlbumCollectionView() {
        collectionView.reloadData()
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
//swiftlint:disable all
}
//swiftlint:enable all
