//
//  TopPodcastsAPI.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 4/10/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import Foundation

class TopPodcastsAPI : APIClient {
    let session: URLSession
    private let baseURL = URL(string: "https://rss.itunes.apple.com/api/v1/us/podcasts/")!

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchTopPodcasts(limit: Int = 50, allowExplicit: Bool = false, completion: @escaping (Result<Response, APIError>) -> Void ) {
        let explicit = allowExplicit ? "explicit" : "non-explicit"
        let path = "top-podcasts/all/\(limit)/\(explicit).json"
        let url = baseURL.appendingPathComponent(path)
        let request = URLRequest(url: url)

        perform(request: request, completion: parseDecodable(completion: completion))
    }
}

extension TopPodcastsAPI {
    struct Response : Decodable {
        let feed: Feed
    }

    struct Feed : Decodable {
        let results: [PodcastResult]
    }

    struct PodcastResult : Decodable {
        let id: String
        let artistName: String
        let name: String
        let artworkUrl100: String
        let genres: [Genre]
    }

    struct Genre: Decodable {
        let name: String
        let genreId: String
    }
}
