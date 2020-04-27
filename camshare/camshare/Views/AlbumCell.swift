//
//  AlbumCell.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/28.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var albumNameLabel: UILabel!
    @IBOutlet var selectedIndicator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override var isHighlighted: Bool {
        didSet {
            selectedIndicator.isHidden = !isHighlighted
        }
    }

    override var isSelected: Bool {
        didSet {
            selectedIndicator.isHidden = !isSelected
        }
    }
}
