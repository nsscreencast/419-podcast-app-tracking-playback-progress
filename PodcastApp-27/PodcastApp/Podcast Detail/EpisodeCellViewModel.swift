//
//  EpisodeCellViewModel.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 7/16/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import Foundation

struct EpisodeCellViewModel {
    private let episode: Episode

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

    init(episode: Episode) {
        self.episode = episode
    }

    var title: String {
        return episode.title ?? "<untitled>"
    }

    var description: String? {
        return episode.description?
            .strippingHTML()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var info: String {
        let parts = [timeString, dateString].compactMap { $0 }
        return parts.joined(separator: " • ")
    }

    private var timeString: String? {
        guard let duration = episode.duration else { return nil }
        return EpisodeCellViewModel.timeFormatter.string(from: duration)
    }

    private var dateString: String? {
        guard let publicationDate = episode.publicationDate else { return nil }
        return EpisodeCellViewModel.dateFormatter.string(from: publicationDate)
    }
}
