//
//  TipsAndTricsTableViewCell.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/04/07.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import camPod

class TipsAndTricsTableViewCell: UITableViewCell {
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var statusSegmentControl: UISegmentedControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func statusChangedSegementControl(_ sender: Any) {

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
