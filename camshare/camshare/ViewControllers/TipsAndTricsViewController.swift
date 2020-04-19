//
//  TipsAndTricsViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/04/07.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import camPod

class TipsAndTricsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tipsTricsTableView: UITableView!
    var tableView: UITableView!
    var tipsAndTricksContent = [TipsAndTricksModel]()
    var youtubeTipsCodeKeys = [String]()
    var youtubeTipsSource = [YoutubeTipsModel]()
    var selectedSegment = 0

    var tipsAndTricksViewModel = TipsAndTricsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        activityIndicator.isHidden = false

        tipsAndTricksViewModel.view = self
        tipsAndTricksViewModel.getRepo = camshareAPIGet()
        tipsAndTricksViewModel.youtubeRepo = YoutubeDataAPI()

        if self.traitCollection.userInterfaceStyle == .light {
            self.navigationController?.navigationBar.backgroundColor = UIColor.white
        } else {
            self.navigationController?.navigationBar.backgroundColor = UIColor.black
        }

        configureTableView()

        tipsAndTricksViewModel.loadTipsAndTricks()
    }

    @IBAction func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            selectedSegment = 0
            tableView.reloadData()
        }

        if segment.selectedSegmentIndex == 1 {
            selectedSegment = 1
            tipsAndTricksViewModel.fetchVideosFromYoutube()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if selectedSegment == 0 {
            count = tipsAndTricksContent.count
        }

        if selectedSegment == 1 {
            count = youtubeTipsSource.count
        }
        return count
    }

    //swiftlint:disable all
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tipsAndTricsCell", for: indexPath) as! TipsAndTricsTableViewCell
    //swiftlint:enable all

        if selectedSegment == 0 {
            cell.webkitView.isHidden = true
            cell.cellView.isHidden = false
            cell.headingLabel.text = tipsAndTricksContent[indexPath.item].heading
            cell.bodyTextView.text = tipsAndTricksContent[indexPath.item].body

            let currentRatingTap = UITapGestureRecognizer(target: self, action: #selector(currentRatingTapped(_:)))
            cell.currentRatingImageView.isUserInteractionEnabled = true
            cell.currentRatingImageView.tag = indexPath.item
            cell.currentRatingImageView.addGestureRecognizer(currentRatingTap)
        }

        if selectedSegment == 1 {
            cell.cellView.isHidden = false
            cell.webkitView.isHidden = false

//            let url = URL(string: "https://youtube.com/embed/\(youtubeTipsCodeKeys[indexPath.item])")
            let url = URL(string: "https://youtube.com/embed/\(self.youtubeTipsSource[indexPath.item].videoId)")
            cell.webkitView.load(URLRequest(url: url!))
        }

        return cell
    }

    @IBAction func currentRatingTapped(_ sender: AnyObject) {
        let indexPath = NSIndexPath(row: sender.view.tag, section: 0)
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            //swiftlint:disable all
            let currentCell = cell as! TipsAndTricsTableViewCell
            //swiftlint:enable all
            currentCell.animateRatings()

            let veryBadRatingTap = UITapGestureRecognizer(target: self, action: #selector(veryBadRatingTapped(_:)))
            let badRatingTap = UITapGestureRecognizer(target: self, action: #selector(badRatingTapped(_:)))
            let okayRatingTap = UITapGestureRecognizer(target: self, action: #selector(okayRatingTapped(_:)))
            let goodRatingTap = UITapGestureRecognizer(target: self, action: #selector(goodRatingTapped(_:)))
            let veryGoodRatingTap = UITapGestureRecognizer(target: self, action: #selector(veryGoodRatingTapped(_:)))
            currentCell.veryBadRatingImageView.addGestureRecognizer(veryBadRatingTap)
            currentCell.badRatingImageView.addGestureRecognizer(badRatingTap)
            currentCell.okayRatingImageView.addGestureRecognizer(okayRatingTap)
            currentCell.goodRatingImageView.addGestureRecognizer(goodRatingTap)
            currentCell.veryGoodRatingImageView.addGestureRecognizer(veryGoodRatingTap)
            currentCell.veryBadRatingImageView.tag = indexPath.row
            currentCell.badRatingImageView.tag = indexPath.row
            currentCell.okayRatingImageView.tag = indexPath.row
            currentCell.goodRatingImageView.tag = indexPath.row
            currentCell.veryGoodRatingImageView.tag = indexPath.row
            currentCell.veryBadRatingImageView.isUserInteractionEnabled = true
            currentCell.badRatingImageView.isUserInteractionEnabled = true
            currentCell.okayRatingImageView.isUserInteractionEnabled = true
            currentCell.goodRatingImageView.isUserInteractionEnabled = true
            currentCell.veryGoodRatingImageView.isUserInteractionEnabled = true
        }
    }

    @IBAction func veryBadRatingTapped(_ sender: AnyObject) {
        let indexPath = NSIndexPath(row: sender.view.tag, section: 0)
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            //swiftlint:disable all
            let currentCell = cell as! TipsAndTricsTableViewCell
            //swiftlint:enable all
            currentCell.currentRatingImageView.image = UIImage(named: "very bad")
            currentCell.animateRatings()
            tableView.reloadData()
        }
    }

    @IBAction func badRatingTapped(_ sender: AnyObject) {
                let indexPath = NSIndexPath(row: sender.view.tag, section: 0)
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            //swiftlint:disable all
            let currentCell = cell as! TipsAndTricsTableViewCell
            //swiftlint:enable all
            currentCell.currentRatingImageView.image = UIImage(named: "bad")
            currentCell.animateRatings()
            tableView.reloadData()
        }
    }

    @IBAction func okayRatingTapped(_ sender: AnyObject) {
        let indexPath = NSIndexPath(row: sender.view.tag, section: 0)
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            //swiftlint:disable all
            let currentCell = cell as! TipsAndTricsTableViewCell
            //swiftlint:enable all
            currentCell.currentRatingImageView.image = UIImage(named: "okay")
            currentCell.animateRatings()
            tableView.reloadData()
        }
    }

    @IBAction func goodRatingTapped(_ sender: AnyObject) {
        let indexPath = NSIndexPath(row: sender.view.tag, section: 0)
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            //swiftlint:disable all
            let currentCell = cell as! TipsAndTricsTableViewCell
            //swiftlint:enable all
            currentCell.currentRatingImageView.image = UIImage(named: "good")
            currentCell.animateRatings()
            tableView.reloadData()
        }
    }

    @IBAction func veryGoodRatingTapped(_ sender: AnyObject) {
        let indexPath = NSIndexPath(row: sender.view.tag, section: 0)
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            //swiftlint:disable all
            let currentCell = cell as! TipsAndTricsTableViewCell
            //swiftlint:enable all
            currentCell.currentRatingImageView.image = UIImage(named: "very good")
            currentCell.animateRatings()
            tableView.reloadData()
        }
    }

    func configureTableView() {
        // View Components
        let segemtedControl = UISegmentedControl(items: ["Cards", "Videos"])
        segemtedControl.selectedSegmentIndex = 0
        segemtedControl.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        segemtedControl.selectedSegmentTintColor = UIColor(red: 24/255, green: 172/255, blue: 251/255, alpha: 1)
        segemtedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

        let context = (navigationController?.navigationBar.bounds.size.height)!
        tableView = UITableView(frame: CGRect(x: view.bounds.origin.x,
                                              y: view.bounds.origin.y + context,
                                              width: view.bounds.size.width,
                                              height: view.bounds.size.height + context),
                                style: .plain)
        view.addSubview(tableView)
        let celNib = UINib(nibName: "TipsAndTricsTableViewCell", bundle: nil)
        tableView.register(celNib, forCellReuseIdentifier: "tipsAndTricsCell")
        tableView.tableHeaderView = segemtedControl
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isHidden = true

        // Contraints
        var layoutGuide: UILayoutGuide!
        layoutGuide = view.layoutMarginsGuide

        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: segemtedControl.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true

        // Delegate and datasource injection
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension TipsAndTricsViewController: TipsAndTricksViewType {
    func updateTableViewYoutubeSource(youtubeTipsModels: [YoutubeTipsModel]) {
        youtubeTipsSource = youtubeTipsModels
    }

    func updateTableViewVideosSource(videoCodes: [String]) {
        youtubeTipsCodeKeys = videoCodes
    }

    public func updateTableViewCardsSource(content: [TipsAndTricksModel]) {
        tipsAndTricksContent = content
    }

    public func didFinishLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }

    public func displayError(error: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    public func reloadTableView() {
        DispatchQueue.main.async { // Correct
            self.tableView.reloadData()
        }
    }
}
