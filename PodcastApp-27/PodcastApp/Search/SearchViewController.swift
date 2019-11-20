//
//  SearchViewController.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 3/7/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

class SearchViewController: PodcastListTableViewController, UISearchResultsUpdating {

    var recommendedPodcasts: [SearchResult] = []
    var results: [SearchResult] = []

    private let dataManager = PodcastDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        search.searchResultsUpdater = self
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false

        loadRecommendedPodcasts()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    private func loadRecommendedPodcasts() {
        dataManager.recommendedPodcasts { result in
            switch result {
            case .success(let podcastResults):
                self.recommendedPodcasts = podcastResults
                self.results = self.recommendedPodcasts
                self.tableView.reloadData()

            case .failure(let error):
                print("Error loading recommended podcasts: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        let term = searchController.searchBar.text ?? ""
        if term.isEmpty {
            resetToRecommendedPodcasts()
            return
        }

        dataManager.search(for: term) { result in
            switch result {
            case .success(let searchResults):
                self.results = searchResults
                self.tableView.reloadData()

            case .failure(let error):
                print("Error searching podcasts: \(error.localizedDescription)")
            }
        }
    }

    private func resetToRecommendedPodcasts() {
        results = recommendedPodcasts
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchResultCell = tableView.dequeueReusableCell(for: indexPath)
        let searchResult = results[indexPath.row]
        cell.configure(with: searchResult)
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = results[indexPath.row]


        dataManager.lookupInfo(for: searchResult) { result in
            switch result {
            case .success(let lookupInfo):
                if let lookupInfo = lookupInfo {
                    self.showPodcast(with: lookupInfo)
                } else {
                    print("Podcast not found")
                }
            case .failure(let error):
                print("Error loading podcast: \(error.localizedDescription)")
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}
