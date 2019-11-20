//
//  PodcastSearchAPI.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 4/25/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import Foundation

class PodcastSearchAPI : APIClient {
    let session: URLSession
    private let baseURL = URL(string: "https://itunes.apple.com/")!

    private var activeSearchTask: URLSessionDataTask?

    init(session: URLSession = .shared) {
        self.session = session
    }

    func search(for term: String, country: String = "us", completion: @escaping (Result<Response, APIError>) -> Void) {
        let url = baseURL.appendingPathComponent("search")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "media", value: "podcast"),
            URLQueryItem(name: "entity", value: "podcast"),
            URLQueryItem(name: "attribute", value: "titleTerm"),
            URLQueryItem(name: "term", value: term)
        ]

        let request = URLRequest(url: components.url!)

        activeSearchTask?.cancel()
        activeSearchTask = perform(request: request, completion: parseDecodable(completion: completion))
    }

    func lookup(id: String, country: String = "us", completion: @escaping (Result<SearchResult?, APIError>) -> Void) {

        let url = baseURL.appendingPathComponent("\(country)/lookup")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "id", value: id)
        ]
        let request = URLRequest(url: components.url!)
        perform(request: request, completion: parseDecodable { (result: Result<Response, APIError>) in
            switch result {
            case .success(let response):
                let result = response.results.first.flatMap(SearchResult.init)
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

extension PodcastSearchAPI {
    struct Response : Decodable {
        let resultCount: Int
        let results: [PodcastSearchResult]
    }

    struct PodcastSearchResult : Decodable {
        let artistName: String
        let collectionId: Int
        let collectionName: String
        let artworkUrl100: String
        let genreIds: [String]
        let genres: [String]
        let feedUrl: String
    }
}
