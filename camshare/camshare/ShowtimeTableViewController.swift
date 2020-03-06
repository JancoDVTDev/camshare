//
//  ShowtimeTableViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/20.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import MediaPlayer

class ShowtimeTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    // MARK: Properties

    @IBOutlet weak var songLengthLabel: UILabel!
    var results = [ResultingClass]()
    let musicPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
    var listOfResults = [ArtistInfo]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.listOfResults.count) Results"
            }
        }
    }
    var playing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleResults()
        searchBar.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ShowtimeResultTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? ShowtimeResultTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }

        let result = listOfResults[indexPath.row]

        cell.descriptionLabel.text = result.trackName
        cell.albumNameLabel.text = result.collectionName
        guard let imageURL = URL(string: listOfResults[indexPath.row].artworkUrl100) else {return cell}

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else {return}
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                cell.profileImage.image = image
            }
        }

        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCellIndex = indexPath.row

        let albumTitleFilter = MPMediaPropertyPredicate(value: listOfResults[selectedCellIndex].collectionName,
                                                        forProperty: MPMediaItemPropertyAlbumTitle,
                                                        comparisonType: .contains)
        let trackTitleFilter = MPMediaPropertyPredicate(value: listOfResults[selectedCellIndex].trackName,
                                                        forProperty: MPMediaItemPropertyTitle,
                                                        comparisonType: .contains)
        let filterSet = Set([albumTitleFilter, trackTitleFilter])
        let query = MPMediaQuery(filterPredicates: filterSet)
        musicPlayer.setQueue(with: query)

        if !playing {
            playing = true
            musicPlayer.play()
            print("Song playing")

        } else {
            playing = false
            musicPlayer.stop()
            print("Song stopped")
        }
    }

    // MARK: Private Methods

    private func loadSampleResults() {
        let photo1 = UIImage(named: "pfImage1")
        let photo2 = UIImage(named: "pfImage2")
        let photo3 = UIImage(named: "pfImage3")

        guard let result1 = ResultingClass(description: "Something about these two", photo: photo1) else {
            fatalError("Unable to instantiate result1")
        }
        guard let result2 = ResultingClass(description: "Be in the spirit", photo: photo2) else {
            fatalError("Unable to instantiate result1")
        }
        guard let result3 = ResultingClass(description: "Walking with you", photo: photo3) else {
            fatalError("Unable to instantiate result1")
        }

        results += [result1, result2, result3]
    }

}

extension ShowtimeTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        let musicRequest = MusicRequest(request: searchBarText)
        musicRequest.getMusicFromiTunes { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let music):
                self?.listOfResults = music
            }
        }
    }
}
