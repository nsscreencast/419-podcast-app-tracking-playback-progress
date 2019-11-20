//
//  ExtendedTabBar.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 8/28/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

class ExtendedTabBar : UITabBar {
    var playerBar: PlayerBar? {
        willSet {
            if newValue != playerBar {
                playerBar?.removeFromSuperview()
            }
        }
        didSet {
            if let playerBar = playerBar {
                install(playerBar: playerBar)
            }
        }
    }

    var playerBarHeight: CGFloat = 0

    private func install(playerBar: PlayerBar) {
        playerBarHeight = playerBar.frame.height
        addSubview(playerBar)
        playerBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerBar.heightAnchor.constraint(equalToConstant: playerBarHeight),
            playerBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            playerBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            playerBar.topAnchor.constraint(equalTo: topAnchor)
            ])
    }

    var playerBarVisible: Bool {
        return playerBar?.isHidden == false
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let originalSize = super.sizeThatFits(size)

        guard playerBarVisible else { return originalSize }
        var modifiedSize = originalSize
        modifiedSize.height += playerBarHeight

        return modifiedSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard playerBarVisible else { return }

        for subview in subviews {
            if let control = subview as? UIControl {
                control.frame.origin.y += playerBarHeight
                control.frame.size.height -= playerBarHeight
            }
        }
    }
}
