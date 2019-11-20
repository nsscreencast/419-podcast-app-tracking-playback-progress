//
//  MyPodcastsViewController.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 10/2/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

class MyPodcastsViewController : PodcastListTableViewController {

    private var store: SubscriptionStore!
    private var subscriptions: [SubscriptionEntity] = [] {
        didSet {
            podcasts = subscriptions.compactMap { $0.podcast }
        }
    }

    private var podcasts: [PodcastEntity] = []
    private var subscriptionChangedObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        store = SubscriptionStore(context: PersistenceManager.shared.mainContext)

        loadSubscriptions()
        subscriptionChangedObserver = NotificationCenter.default
            .addObserver(SubscriptionsChanged.self,
                         sender: nil,
                         queue: .main,
                         using: { change in
                            self.loadSubscriptions()
            })
    }

    private func loadSubscriptions() {
        do {
            subscriptions = try store.fetchSubscriptions()
            tableView.reloadData()
        } catch {
            print("ERROR: ", error.localizedDescription)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PodcastCell = tableView.dequeueReusableCell(for: indexPath)
        let podcast = podcasts[indexPath.row]
        cell.configure(with: podcast)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcast = podcasts[indexPath.row]
        if let lookup = podcast.lookupInfo {
            showPodcast(with: lookup)
        }
    }
}
