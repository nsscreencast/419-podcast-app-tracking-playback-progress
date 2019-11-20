//
//  SearchResult.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 3/7/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

class SearchResult {
    var id: String
    var artworkUrl: URL?
    var title: String
    var author: String
    var feedURL: URL?

    init(id: String, artworkUrl: URL?, title: String, author: String, feedURL: URL?) {
        self.id = id
        self.artworkUrl = artworkUrl
        self.title = title
        self.author = author
        self.feedURL = feedURL
    }
}

extension SearchResult {
    convenience init(podcastResult: TopPodcastsAPI.PodcastResult) {
        self.init(
            id: podcastResult.id,
            artworkUrl: URL(string: podcastResult.artworkUrl100),
            title: podcastResult.name,
            author: podcastResult.artistName,
            feedURL: nil
        )
    }
}

extension SearchResult {
    convenience init(searchResult: PodcastSearchAPI.PodcastSearchResult) {
        self.init(
            id: String(searchResult.collectionId),
            artworkUrl: URL(string: searchResult.artworkUrl100),
            title: searchResult.collectionName,
            author: searchResult.artistName,
            feedURL: URL(string: searchResult.feedUrl))
    }
}

extension SearchResult : PodcastCellModel {
    var titleText: String? {
        return title
    }

    var authorText: String? {
        return author
    }

    var artwork: URL? { return artworkUrl }
}
