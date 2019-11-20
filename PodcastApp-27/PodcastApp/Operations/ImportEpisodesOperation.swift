//
//  ImportEpisodesOperation.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 10/18/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import Foundation
import CoreData

class ImportEpisodesOperation : BaseOperation {

    private let podcastId: String
    private let feedLoader = PodcastFeedLoader()
    private var context: NSManagedObjectContext!
    private var subscriptionStore: SubscriptionStore!

    init(podcastId: String) {
        self.podcastId = podcastId
    }

    override func execute() {
        context = PersistenceManager.shared.newBackgroundContext()
        subscriptionStore = SubscriptionStore(context: context)

        // load podcast
        print("ImportEpisodes -> Loading podcast: \(podcastId)")
        guard let podcastEntity = loadPodcast() else {
            finish()
            return
        }

        // import the feed
        print("ImportEpisodes -> Fetching the feed for \(podcastEntity.title ?? "<?>") - \(podcastEntity.feedURLString ?? "<?>")")
        guard let lookup = podcastEntity.lookupInfo else {
            print("Couldn't build lookup info")
            finish()
            return
        }

        feedLoader.fetch(lookup: lookup) { result in
            switch result {
            case .failure(let error):
                print("Error loading feed: \(error.localizedDescription)")
                self.finish()

            case .success(let podcast):
                self.importEpisodes(podcast.episodes, podcast: podcastEntity)
                self.saveChanges()
                self.finish()
                print("updated \(podcast.title ?? "") (\(podcast.episodes.count) episodes)")
            }
        }
    }

    private func saveChanges() {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("Error saving changes: \(error.localizedDescription)")
            }
        }
    }

    private func loadPodcast() -> PodcastEntity? {
        do {
            guard let podcast = try subscriptionStore.findPodcast(with: podcastId) else {
                print("Couldn't find podcast with id: \(podcastId)")
                return nil
            }
            return podcast
        } catch {
            print("Error fetching podcast: \(error.localizedDescription)")
            return nil
        }
    }

    private func importEpisodes(_ episodes: [Episode], podcast: PodcastEntity) {
        var existingEpisodes = [String : EpisodeEntity]()
        podcast.episodes?
            .map { $0 as! EpisodeEntity }
            .forEach {
                existingEpisodes[$0.identifier] = $0
            }

        for episode in episodes {
            guard let episodeId = episode.identifier else {
                print("Skipping episode \(episode.title ?? "<?>") because it has no identifier")
                continue
            }

            guard let enclosureURL = episode.enclosureURL else {
                print("Skipping episode \(episode.title ?? "<?>") because it has no enclosure")
                continue
            }

            let episodeEntity = existingEpisodes[episodeId] ?? EpisodeEntity(context: context)
            episodeEntity.identifier = episodeId
            episodeEntity.podcast = podcast
            episodeEntity.title = episode.title ?? "Untitled"
            episodeEntity.publicationDate = episode.publicationDate ?? Date()
            episodeEntity.duration = episode.duration ?? 0
            episodeEntity.episodeDescription = episode.description ?? ""
            episodeEntity.enclosureURL = enclosureURL

            print("Importing [\(podcast.title ?? "")] \(episodeEntity.title)...")
        }
    }
}
