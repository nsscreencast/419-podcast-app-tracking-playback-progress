//
//  PodcastDetailViewController.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 5/14/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

class PodcastDetailViewController : UITableViewController {
    var podcastLookupInfo: PodcastLookupInfo!

    private var store: SubscriptionStore!

    private var podcast: Podcast? {
        didSet {
            podcastViewModel = podcast.flatMap {
                PodcastViewModel(podcast: $0,
                                 isSubscribed: store.isSubscribed(to: $0.id))
            }
        }
    }

    private var podcastViewModel: PodcastViewModel? {
        didSet {
            headerViewController.podcast = podcastViewModel
            tableView.reloadData()
        }
    }

    var headerViewController: PodcastDetailHeaderViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        store = SubscriptionStore(context: PersistenceManager.shared.mainContext)

        tableView.backgroundColor = Theme.Colors.gray5
        tableView.separatorColor = Theme.Colors.gray4

        headerViewController = children.compactMap { $0 as? PodcastDetailHeaderViewController }.first
        headerViewController.subscribeButton.addTarget(self, action: #selector(subscribeTapped(_:)), for: .touchUpInside)

        loadPodcast()

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
    }

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private func loadPodcast() {
        activityIndicatorView.startAnimating()
        PodcastFeedLoader().fetch(lookup: podcastLookupInfo) { result in
            self.activityIndicatorView.stopAnimating()
            switch result {
            case .success(let podcast):
                self.podcast = podcast
            case .failure(let error):
                self.headerViewController.clearUI()
                print("Error with feed: \(self.podcastLookupInfo.feedURL.absoluteString)")
                let alert = UIAlertController(title: "Failed to Load Podcast", message: "Error loading feed: \(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                    self.loadPodcast()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcastViewModel?.episodes.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EpisodeCell = tableView.dequeueReusableCell(for: indexPath)

        if let episode = podcastViewModel?.episodes[indexPath.row] {
            cell.configure(with: episode)
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let podcast = podcast else { return }
        let episode = podcast.episodes[indexPath.row]

        let player = PlayerViewController.shared
        player.setEpisode(episode, podcast: podcast)
        present(player, animated: true, completion: nil)
    }

    // MARK: - Scrolling

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustHeaderParallax(scrollView)
    }

    private func adjustHeaderParallax(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let headerView = headerViewController.view
        if offsetY < 0 {
            headerView?.superview?.clipsToBounds = false
            headerView?.transform = CGAffineTransform(translationX: 0, y: offsetY/10)
            headerView?.alpha = 1.0
        } else {
            headerView?.superview?.clipsToBounds = true
            headerView?.transform = CGAffineTransform(translationX: 0, y: offsetY/3)
            headerView?.alpha = 1 - (offsetY / headerView!.frame.height * 0.9)
        }
    }

    // MARK: - Event Handling

    @objc private func subscribeTapped(_ sender: SubscribeButton) {
        guard let podcast = podcast else { return }
        let isSubscribing = !sender.isSelected
        do {

            if isSubscribing {
                try store.subscribe(to: podcast)
            } else {
                try store.unsubscribe(from: podcast)
            }
            sender.isSelected.toggle()
        } catch {
            let action = isSubscribing ? "Subscribing to Podcast" : "Unsubscribing from Podcast"
            let alert = UIAlertController(title: "Error \(action)", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
    }
}
