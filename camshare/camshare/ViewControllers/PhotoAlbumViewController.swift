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
//swiftlint:disable all
class PhotoAlbumViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, WCSessionDelegate {
//swiftlint:enable all
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
    var currentUser: camPod.UserCampod?
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

    //var albumViewModelOLD = AlbumViewModelOLD()
    let allUserAlbums = ShowingAllUserAlbumsViewModel()
    var userAlbumNames = [String]()

    lazy var selectBarButtonItem: UIBarButtonItem = {
        let barbuttonItem = UIBarButtonItem(title: "Select", style: .plain, target: self,
                                            action: #selector(self.tappedSelectButton(_:)))
        return barbuttonItem
    }()

    lazy var deleteBarButtonItem: UIBarButtonItem = {
        let barbuttonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self,
                                            action: #selector(self.tappedDeleteButton(_:)))
        barbuttonItem.tintColor = .systemRed
        return barbuttonItem
    }()

    lazy var profileBarButtonItem: UIBarButtonItem = {
        let barbuttonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"),
                                            style: .plain, target: self,
                                            action: #selector(self.tappedProfileButton(_:)))
        return barbuttonItem
    }()

    var selectedIndexPathDictionary: [IndexPath: Bool] = [:]

    var mode: CurrentMode = .view {
        didSet {
            switch mode {
            case .view:
                for (key, value) in selectedIndexPathDictionary where value {
                    collectionView.deselectItem(at: key, animated: true)
                }

                selectedIndexPathDictionary.removeAll()

                selectBarButtonItem.title = "Select"
                navigationItem.rightBarButtonItems = [profileBarButtonItem, selectBarButtonItem]
                collectionView.allowsMultipleSelection = false
            case .select:
                selectBarButtonItem.title = "Cancel"
                navigationItem.rightBarButtonItems = [deleteBarButtonItem, selectBarButtonItem]
                collectionView.allowsMultipleSelection = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        collectionView.isHidden = true

        albumViewModel.view = self
        albumViewModel.repo = AlbumDataSource()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                           target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [profileBarButtonItem, selectBarButtonItem]

        configureWatchKitSession()
        albumViewModel.loadAlbums()
    }

    override func viewDidAppear(_ animated: Bool) {
        if isViewLoaded {
            albumViewModel.loadAlbums()
        }
    }

    func configureWatchKitSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    @objc func tappedProfileButton(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Confirm", message: nil, preferredStyle: .actionSheet)

        let actionSignout = UIAlertAction(title: "Sign Out", style: .destructive) { (_) in
            do {
                try Auth.auth().signOut()
            } catch {
                let alert = UIAlertController(title: "Error", message: "Cannot Sign Out", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            self.transitionToStartUp()
        }

        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionSheet.addAction(actionSignout)
        actionSheet.addAction(actionCancel)
        present(actionSheet, animated: true, completion: nil)
    }

    @objc func tappedSelectButton(_ sender: AnyObject) {
        mode = mode == .view ? .select: .view
    }

    @objc func tappedDeleteButton(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Delete Album ?",
                                      message: "Does not effect other members of the album",
                                      preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            var deleteIndexPaths = [IndexPath]()
            var deleteAlbumIDs = [String]()
            for (key, value) in self.selectedIndexPathDictionary where value {
                deleteIndexPaths.append(key)
                deleteAlbumIDs.append(self.albumsCollectionViewSource[key.item].albumID)
            }

            for albumID in deleteAlbumIDs {
                self.userAlbumIDs.removeAll { $0 == albumID } // send in the viewmodel function
            }

            for index in deleteIndexPaths.sorted(by: { $0.item > $1.item }) {
                self.albumsCollectionViewSource.remove(at: index.item)
            }

            self.collectionView.deleteItems(at: deleteIndexPaths)

            self.albumViewModel.deleteAlbums(updatedAlbumIDs: self.userAlbumIDs)
            self.selectedIndexPathDictionary.removeAll()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert](_) in
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

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.trackAnalytics.log(name: NameConstants.cancelAdd, parameters: nil)
        }

        actionSheet.addAction(createNewAction)
        actionSheet.addAction(scanQRCode)
        actionSheet.addAction(existingAlbumAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }

    func transitionToStartUp() {
        DispatchQueue.main.async {
            let startUpViewController = self.storyboard?.instantiateViewController(identifier:
                Constants.Storyboard.startUpViewController)
            self.view.window?.rootViewController = startUpViewController
            self.view.window?.makeKeyAndVisible()
        }
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

    }

    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {

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
        cell.imageView.isUserInteractionEnabled = true
        cell.imageView.tag = indexPath.row
        let image = albumsCollectionViewSource[indexPath.item].thumbnail
        cell.imageView.image = image
        cell.albumNameLabel.text = albumsCollectionViewSource[indexPath.item].name
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mode {
        case .view:
            collectionView.deselectItem(at: indexPath, animated: true)
            selectedIndex = indexPath.item
            performSegue(withIdentifier: "loadAlbum", sender: self)
        case .select:
            selectedIndexPathDictionary[indexPath] = true
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mode == .select {
            selectedIndexPathDictionary[indexPath] = false
        }
    }

    @IBAction func selectToEdit(_ sender: AnyObject) {
        selectedIndexForEditing = sender.view.tag
        isCellSelected = true
        collectionView.reloadData()
        print("Finished loading - Present popup")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // MARK: OBJECTIVE C Controller
        //swiftlint:disable all
        if segue.identifier == "loadAlbum" {
            let photosViewController = segue.destination as! PhotosViewController
            photosViewController.albumID = self.albumsCollectionViewSource[self.selectedIndex].albumID
            photosViewController.userImagePaths = self.albumsCollectionViewSource[self.selectedIndex].imagePaths
            photosViewController.albumName = self.albumsCollectionViewSource[self.selectedIndex].name
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

}
enum CurrentMode {
    case view
    case select
    //swiftlint:disable all
}
//swiftlint:enable all
