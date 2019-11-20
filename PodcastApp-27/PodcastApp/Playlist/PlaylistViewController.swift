//
//  PlaylistViewController.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 10/28/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData

class PlaylistViewController : UITableViewController {

    enum Section {
        case main
    }

    private var datasource: UITableViewDiffableDataSource<Section, PlaylistCellViewModel>!
    private var fetchedResultsController: NSFetchedResultsController<EpisodeEntity>!
    private var needsSnapshotUpdate = false

    override func viewDidLoad() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 94

        tableView.separatorInset = .zero
        tableView.backgroundColor = Theme.Colors.gray4
        tableView.separatorColor = Theme.Colors.gray3

        datasource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
            let cell: PlaylistCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: model)
            return cell
        })

        let context = PersistenceManager.shared.mainContext
        let store = SubscriptionStore(context: context)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: store.playlistFetchRequest(),
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            needsSnapshotUpdate = true
        } catch {
            print("Error fetching playlist: ", error)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if needsSnapshotUpdate {
            updateSnapshot()
            needsSnapshotUpdate = false
        }
    }

    private func updateSnapshot() {
        let episodes = fetchedResultsController.fetchedObjects ?? []
        var snapshot = NSDiffableDataSourceSnapshot<Section, PlaylistCellViewModel>()
        snapshot.appendSections([.main])

        let viewModels = episodes.map(PlaylistCellViewModel.init)
        snapshot.appendItems(viewModels, toSection: .main)

        datasource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

extension PlaylistViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if view.window != nil {
            updateSnapshot()
        } else {
            needsSnapshotUpdate = true
        }
    }
}
