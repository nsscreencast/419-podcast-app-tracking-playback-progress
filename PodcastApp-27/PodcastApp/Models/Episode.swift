//
//  Episode.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 7/16/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import Foundation

class Episode {
    var identifier: String?
    var title: String?
    var description: String?
    var publicationDate: Date?
    var duration: TimeInterval?
    var enclosureURL: URL?

    init() {        
    }

    init(from entity: EpisodeEntity) {
        identifier = entity.identifier
        title = entity.title
        description = entity.episodeDescription
        publicationDate = entity.publicationDate
        duration = entity.duration
        enclosureURL = entity.enclosureURL
    }
}
