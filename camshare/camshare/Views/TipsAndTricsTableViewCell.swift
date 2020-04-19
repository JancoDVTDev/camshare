//
//  TipsAndTricsTableViewCell.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/04/07.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import camPod
import WebKit

class TipsAndTricsTableViewCell: UITableViewCell {

    // https://www.youtube.com/watch?v=-syN8aFZz0w
    // https://www.appcoda.com/youtube-api-ios-tutorial/
    // https://www.youtube.com/watch?v=RmHqOSrkZnk
    @IBOutlet var webkitView: WKWebView!
    @IBOutlet var cellView: UIView!
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var currentRatingImageView: UIImageView!
    @IBOutlet var veryBadRatingImageView: UIImageView!
    @IBOutlet var badRatingImageView: UIImageView!
    @IBOutlet var okayRatingImageView: UIImageView!
    @IBOutlet var goodRatingImageView: UIImageView!
    @IBOutlet var veryGoodRatingImageView: UIImageView!

    @IBOutlet var currentLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var verybadLeadingContraint: NSLayoutConstraint!
    @IBOutlet var badLeadingContraint: NSLayoutConstraint!
    @IBOutlet var okayLeadingContraint: NSLayoutConstraint!
    @IBOutlet var goodLeadingContraint: NSLayoutConstraint!
    @IBOutlet var veryGoodLeadingContraint: NSLayoutConstraint!
    var didTapCell = false
    override func awakeFromNib() {
        super.awakeFromNib()
        webkitView.isHidden = true

        // Initialization code
        cellView.layer.cornerRadius = 4
        cellView.layer.shadowColor = UIColor.darkGray.cgColor
        cellView.layer.shadowOpacity = 0.75
        cellView.layer.shadowRadius = 2
        cellView.layer.shadowOffset = .zero

        verybadLeadingContraint.constant -= self.bounds.width
        badLeadingContraint.constant -= self.bounds.width
        okayLeadingContraint.constant -= self.bounds.width
        goodLeadingContraint.constant -= self.bounds.width
        veryGoodLeadingContraint.constant -= self.bounds.width

    }

    func animateRatings() {
        didTapCell = !didTapCell
        if didTapCell {
            showRatings()
            ratingsSlideIntoView()
        } else {
            ratingSlideOutOfView()
            //hideRatings()
        }
    }

    private func showRatings() {
        veryBadRatingImageView.isHidden = false
        badRatingImageView.isHidden = false
        okayRatingImageView.isHidden = false
        goodRatingImageView.isHidden = false
        veryGoodRatingImageView.isHidden = false
    }

    private func ratingsSlideIntoView() {
        verybadLeadingContraint.constant = currentLeadingConstraint.constant
        badLeadingContraint.constant = verybadLeadingContraint.constant
        okayLeadingContraint.constant = badLeadingContraint.constant
        goodLeadingContraint.constant = okayLeadingContraint.constant
        veryGoodLeadingContraint.constant = goodLeadingContraint.constant

        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }

    private func ratingSlideOutOfView() {
        verybadLeadingContraint.constant -= self.bounds.width
        badLeadingContraint.constant -= self.bounds.width
        okayLeadingContraint.constant -= self.bounds.width
        goodLeadingContraint.constant -= self.bounds.width
        veryGoodLeadingContraint.constant -= self.bounds.width

        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }

    private func hideRatings() {
        veryBadRatingImageView.isHidden = true
        badRatingImageView.isHidden = true
        okayRatingImageView.isHidden = true
        goodRatingImageView.isHidden = true
        veryGoodRatingImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
