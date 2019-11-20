//
//  PodcastDetailHeaderViewController.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 5/14/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit
import Kingfisher

class PodcastDetailHeaderViewController : UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!

    var podcast: PodcastViewModel? {
        didSet {
            if isViewLoaded, let podcast = podcast {
                UIView.animate(withDuration: 0.4) {
                    self.updateUI(for: podcast)
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    func clearUI() {
        imageView.image = nil
        titleLabel.text = nil
        authorLabel.text = nil
        genreLabel.text = nil
        descriptionLabel.text = nil
        subscribeButton.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let podcast = podcast {
            updateUI(for: podcast)
        } else {
            clearUI()
        }
    }

    private func updateUI(for podcast: PodcastViewModel) {
        subscribeButton.isEnabled = true
        subscribeButton.isSelected = podcast.isSubscribed
        
        let options: KingfisherOptionsInfo = [.transition(.fade(1.0))]

        imageView.kf.setImage(with: podcast.artworkURL, placeholder: nil, options: options)

        titleLabel.text = podcast.title
        authorLabel.text = podcast.author
        genreLabel.text = podcast.genre
        descriptionLabel.text = podcast.description
    }
}
