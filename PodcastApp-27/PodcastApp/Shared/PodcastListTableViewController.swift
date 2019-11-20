//
//  PodcastListTableViewController.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 10/2/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

class PodcastListTableViewController : UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorInset = .zero
        tableView.backgroundColor = Theme.Colors.gray4
        tableView.separatorColor = Theme.Colors.gray3
    }

    func showPodcast(with lookupInfo: PodcastLookupInfo) {
        let detailVC = UIStoryboard(name: "PodcastDetail", bundle: nil).instantiateInitialViewController() as! PodcastDetailViewController
        detailVC.podcastLookupInfo = lookupInfo
        show(detailVC, sender: self)
    }
}
