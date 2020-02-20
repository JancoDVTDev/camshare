//
//  ShowtimeResultOptions.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/20.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit

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
    // MARK: Button Action
    @objc func playButtonTapped(button: UIButton) {
        print("Play Button pressed")
    }

    @objc func addButtonTapped(button: UIButton) {
        print("Add Button pressed")
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
