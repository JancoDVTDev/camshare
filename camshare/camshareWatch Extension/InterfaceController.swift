//
//  InterfaceController.swift
//  camshareWatch Extension
//
//  Created by Janco Erasmus on 2020/04/24.
//  Copyright © 2020 DVT. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var albumName: WKInterfaceLabel!
    @IBOutlet var albumsTable: WKInterfaceTable!

    let session = WCSession.default
    var requestSession: WCSession?
    var tableGroupData = [String: String]()
    var albumNames = [String]()
    var qrCodes = [UIImage]()
    var selectedQRCode = UIImage()
    var selectedAlbumName = String()
    var qrData = [Data]()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        session.delegate = self
        session.activate()
    }

    @IBAction func tappedRefreshButton() {
        if let validSession = self.requestSession, validSession.isReachable {
            let data = ["Request": "Update"]
            validSession.sendMessage(data, replyHandler: nil, errorHandler: nil)
        }
    }

    func loadTable() {
        albumsTable.setNumberOfRows(tableGroupData.count, withRowType: "AlbumRow")

        var count = 0
        for (name, _) in tableGroupData {
            let albumName = name
            albumNames.append(albumName)
            guard let controller = albumsTable.rowController(at: count) as? AlbumRowController else {
                continue
            }
            controller.albumName.setText(albumName)
            count += 1
        }
    }

    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        selectedQRCode = qrCodes[rowIndex]
        selectedAlbumName = albumNames[rowIndex]
        let data = ["Name": selectedAlbumName, "QRCode": selectedQRCode] as [String: Any]
        pushController(withName: "QRCodeScene", context: data)
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("recieved data: \(message)")
        if let value = message["Albums"] as? [String: String] {
            tableGroupData = value
            loadTable()
        }

        if let images = message["ImageCodes"] as? [Data] {
            qrData = images
            for index in 0..<qrData.count {
                let image = UIImage(data: qrData[index])
                qrCodes.append(image!)
            }
        }
    }
}
