//
//  PlaylistCellViewModel.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 11/14/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import Foundation

struct PlaylistCellViewModel : Hashable {
    private let episode: EpisodeEntity

    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    private static var timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()

    init(episode: EpisodeEntity) {
        self.episode = episode
    }

    var title: String {
        return episode.title
    }

    var podcastTitle: String? {
        return episode.podcast.title
    }

    var artworkURL: URL? {
        return episode.podcast.artworkURL
    }

    var description: String {
        return episode.description
            .strippingHTML()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var info: String {
        let parts = [timeString, dateString].compactMap { $0 }
        return parts.joined(separator: " • ")
    }

    private var timeString: String? {
        return Self.timeFormatter.string(from: episode.duration)
    }

    private var dateString: String {
        return Self.dateFormatter.string(from: episode.publicationDate)
    }
}
