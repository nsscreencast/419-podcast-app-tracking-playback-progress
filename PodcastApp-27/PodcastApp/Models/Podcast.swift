//
//  Podcast.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 5/7/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import Foundation

class Podcast {
    var id: String
    var feedURL: URL
    var title: String?
    var author: String?
    var description: String?
    var primaryGenre: String?
    var artworkURL: URL?
    var episodes: [Episode] = []

    init(id: String, feedURL: URL) {
        self.id = id
        self.feedURL = feedURL
    }

    init(from entity: PodcastEntity) {
        id = entity.id!
        feedURL = URL(string: entity.feedURLString!)!
        title = entity.title
        author = entity.author
        description = entity.podcastDescription
        primaryGenre = entity.genre
        artworkURL = entity.artworkURL
    }
}
