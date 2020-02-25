//
//  MusicResult.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/20.
//  Copyright © 2020 DVT. All rights reserved.
//

import Foundation

struct MusicObjects: Decodable {
    var object: AllResults
}

struct AllResults: Decodable {
    var results: [ArtistInfo]
}

struct ArtistInfo: Decodable {
    var artistName: String
    var collectionName: String
    var trackName: String
    var artworkUrl100: String
    var primaryGenreName: String
    var trackTimeMillis: Int
}
