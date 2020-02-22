//
//  ShowtimeResultOptions.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/20.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import MediaPlayer

@IBDesignable class ShowtimeResultOptions: UIStackView {

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    var playing: Bool = false
    let musicPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer // Get the music player.
    // MARK: Button Action
    @objc func playButtonTapped(button: UIButton) {
        // musicPlayer.setQueue(with: .songs()) // Add a playback queue containing all songs on the device.
        /*
        let albumTitleFilter =
            MPMediaPropertyPredicate(value: "Voel Jy Die Genade",
                                     forProperty: MPMediaItemPropertyAlbumTitle,
                                     comparisonType: .equalTo)

        let songTitleFilter =
            MPMediaPropertyPredicate(value: "Bitter",
                                     forProperty: MPMediaItemPropertyTitle,
                                     comparisonType: .contains)

        //let filterSet = Set([albumTitleFilter, songTitleFilter])

        //let query = MPMediaQuery(filterPredicates: filterSet)
        //musicPlayer.setQueue(with: query)
        */

        if !playing {
            playing = true
            //musicPlayer.play()
            print("Song playing")

        } else {
            playing = false
            //musicPlayer.stop()
            print("Song stopped")
        }
    }

    @objc func addButtonTapped(button: UIButton) {
        //print(musicPlayer.nowPlayingItem?.title)
        musicPlayer.skipToNextItem()
    }

    @objc func albumButtonTapped(button: UIButton) {
        print("Album Button pressed")
    }

    // MARK: Private Functions
    private func setupButtons() {
        let playButton = UIButton()
        playButton.setImage(UIImage(systemName: "playpause"), for: .normal)

        let addButton = UIButton()
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)

        let albumButton = UIButton()
        albumButton.setImage(UIImage(systemName: "music.note.list"), for: .normal)

        // Add Contraints
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true

        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true

        albumButton.translatesAutoresizingMaskIntoConstraints = false
        albumButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        albumButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true

        // Setup the button action
        playButton.addTarget(self, action: #selector(ShowtimeResultOptions.playButtonTapped(button:)),
                             for: .touchUpInside)
        addButton.addTarget(self, action: #selector(ShowtimeResultOptions.addButtonTapped(button:)),
                                    for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(ShowtimeResultOptions.albumButtonTapped(button:)),
                                    for: .touchUpInside)

        // Add the buttons to the stack
        addArrangedSubview(playButton)
        addArrangedSubview(addButton)
        addArrangedSubview(albumButton)
    }
}
