//
//  MusicRequest.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/20.
//  Copyright © 2020 DVT. All rights reserved.
//

import Foundation
import FuncLibrary //- Import your library name

enum MusicError: Error {
    case noDataAvailable
    case cannotProcessData
}

struct MusicRequest {
    let resourceURL: URL
    //let API_KEY = "Your api key will go here" - NOT needed in this case

    init(request: String) {
        let resourceString = "https://itunes.apple.com/search?term=\(request)"
        //let //cleanedResourceString = resourceString.replacingOccurrences(of: " ", with: "%20")
        guard let resourceURL = URL(string: resourceString) else {fatalError()}

        self.resourceURL = resourceURL
    }

    func getMusicFromiTunes(completion: @escaping(Result<[ArtistInfo], MusicError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }

            do {
                let decoder = JSONDecoder()
                let musicResponse = try decoder.decode(AllResults.self, from: jsonData)
                let artistInfo = musicResponse.results
                (completion(.success(artistInfo)))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        dataTask.resume()
    }
}
