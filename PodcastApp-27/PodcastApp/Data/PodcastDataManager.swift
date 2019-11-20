//
//  PodcastDataManager.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 7/3/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import Foundation

class PodcastDataManager {
    private let topPodcastsAPI = TopPodcastsAPI()
    private let searchClient = PodcastSearchAPI()

    func recommendedPodcasts(completion: @escaping (Result<[SearchResult], PodcastLoadingError>) -> Void) {
        topPodcastsAPI.fetchTopPodcasts(limit: 50, allowExplicit: false) { result in
            switch result {
            case .success(let response):
                let searchResults = response.feed.results.map(SearchResult.init)
                completion(.success(searchResults))

            case .failure(let error):
                completion(.failure(PodcastLoadingError.convert(from: error)))
            }
        }
    }

    func search(for term: String, completion: @escaping (Result<[SearchResult], PodcastLoadingError>) -> Void) {
        searchClient.search(for: term) { result in
            switch result {
            case .success(let response):
                let searchResults = response.results.map(SearchResult.init)
                completion(.success(searchResults))

            case .failure(let error): completion(.failure(PodcastLoadingError.convert(from: error)))
            }
        }
    }

    func lookup(podcastID: String, completion: @escaping (Result<SearchResult?, APIError>) -> Void) {
        searchClient.lookup(id: podcastID) { result in
            completion(result)
        }
    }

    /// Returns an object reuqired to lookup the details of a podcast. If the requisite properties are present on the searchResult,
    /// the object is returned in the callback immediately. Otherwise a call to the iTunes API is made to fetch the missing data before the callback.
    func lookupInfo(for searchResult: SearchResult, completion: @escaping (Result<PodcastLookupInfo?, APIError>) ->  Void) {
        if let feed = searchResult.feedURL {
            let lookup = PodcastLookupInfo(id: searchResult.id, feedURL: feed)
            completion(.success(lookup))
        } else {
            searchClient.lookup(id: searchResult.id) { result in
                switch result {
                case .success(let updatedResult):
                    let lookupInfo = updatedResult?.feedURL.flatMap({ PodcastLookupInfo(id: searchResult.id, feedURL: $0) })

                    completion(.success(lookupInfo))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

}
