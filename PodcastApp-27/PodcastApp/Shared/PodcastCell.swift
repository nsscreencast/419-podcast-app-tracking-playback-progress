//
//  PodcastCell.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 10/2/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit
import Kingfisher

protocol PodcastCellModel {
    var titleText: String? { get }
    var authorText: String? { get }
    var artwork: URL? { get }
}

class PodcastCell : UITableViewCell {

    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var podcastTitleLabel: UILabel!
    @IBOutlet weak var podcastAuthorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        artworkImageView.backgroundColor = Theme.Colors.gray3
        artworkImageView.layer.cornerRadius = 10
        artworkImageView.layer.masksToBounds = true

        backgroundColor = Theme.Colors.gray4
        backgroundView = UIView()
        backgroundView?.backgroundColor = Theme.Colors.gray4

        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = Theme.Colors.gray3

        podcastTitleLabel.textColor = Theme.Colors.gray0
        podcastAuthorLabel.textColor = Theme.Colors.gray1
    }

    func configure(with model: PodcastCellModel) {
        podcastTitleLabel.text = model.titleText
        podcastAuthorLabel.text = model.authorText
        if let url = model.artwork {
            let options: KingfisherOptionsInfo = [
                .transition(.fade(0.5))
            ]
            artworkImageView.kf.setImage(with: url, options: options)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        podcastTitleLabel.text = nil
        podcastAuthorLabel.text = nil

        artworkImageView.kf.cancelDownloadTask()
        artworkImageView.image = nil
    }

}
