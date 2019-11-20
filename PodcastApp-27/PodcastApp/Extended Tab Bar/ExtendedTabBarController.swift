//
//  ExtendedTabBarController.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 8/28/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

class ExtendedTabBarController : UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()

        let player = PlayerViewController.shared
        player.presentationRootController = self

        let playerBar = player.playerBar
        // install this in the tab bar
        (tabBar as? ExtendedTabBar)?.playerBar = playerBar
    }
}
