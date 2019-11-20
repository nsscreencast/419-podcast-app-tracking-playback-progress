//
//  FeedImporter.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 10/18/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import Foundation

class FeedImporter {
    static let shared = FeedImporter()

    private var notificationObserver: NSObjectProtocol?
    private var priorityQueue: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 2
        q.qualityOfService = .userInitiated
        return q
    }()

    private var backgroundQueue: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 2
        q.qualityOfService = .background
        return q
    }()

    func startListening() {
        notificationObserver = NotificationCenter.default.addObserver(SubscriptionsChanged.self, sender: nil, queue: nil) { notification in
            notification.subscribedIds.forEach(self.onSubscribe)
            notification.unsubscribedIds.forEach(self.onUnsubscribe)
        }
    }

    func updatePodcasts() {
        backgroundQueue.addOperation {
            let context = PersistenceManager.shared.newBackgroundContext()
            let subscriptionStore = SubscriptionStore(context: context)
            do {
                let subs = try subscriptionStore.fetchSubscriptions()
                for sub in subs {
                    guard let podcast = sub.podcast else { continue }
                    guard let id = podcast.id else { continue }
                    print("Queueing operation to update subscribed podcast: \(podcast.title ?? "?")")
                    let updateOperation = ImportEpisodesOperation(podcastId: id)
                    self.backgroundQueue.addOperation(updateOperation)
                }
            } catch {
                print("Error fetching subscriptions for background update. \(error)")
            }
        }
    }

    private func onSubscribe(podcastId: String) {
        let operation = ImportEpisodesOperation(podcastId: podcastId)
        priorityQueue.addOperation(operation)
    }

    private func onUnsubscribe(podcastId: String) {

    }
}

