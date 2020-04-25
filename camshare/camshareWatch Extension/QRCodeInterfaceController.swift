//
//  QRCodeInterfaceController.swift
//  camshareWatch Extension
//
//  Created by Janco Erasmus on 2020/04/25.
//  Copyright © 2020 DVT. All rights reserved.
//

import WatchKit
import Foundation

class QRCodeInterfaceController: WKInterfaceController {
    @IBOutlet var albumNameLabel: WKInterfaceLabel!
    @IBOutlet var QRCodeImageView: WKInterfaceImage!

    var albumID = "Did not work!"

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        //swiftlint:disable all
        let dictionary = context as? NSDictionary
        if dictionary != nil {
            let albumName = dictionary!["Name"] as! String
            let qrCodeImage = dictionary!["QRCode"] as! UIImage
            self.albumNameLabel.setText(albumName)
            self.QRCodeImageView.setImage(qrCodeImage)
        }
        //swiftlint:enable all
    }
    
    func setupImageView() {
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
