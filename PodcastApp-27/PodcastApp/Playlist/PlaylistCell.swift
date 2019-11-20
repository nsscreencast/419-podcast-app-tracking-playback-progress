//
//  PlaylistCell.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 10/28/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

class PlaylistCell : UITableViewCell {

    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var podcastLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        artworkImageView.backgroundColor = Theme.Colors.gray3
        artworkImageView.layer.cornerRadius = 6
        artworkImageView.layer.masksToBounds = true

        backgroundColor = Theme.Colors.gray4
        backgroundView = UIView()
        backgroundView?.backgroundColor = Theme.Colors.gray4

        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = Theme.Colors.gray3

        episodeTitleLabel.textColor = Theme.Colors.gray0
        podcastLabel.textColor = Theme.Colors.gray1
        durationLabel.textColor = Theme.Colors.gray2
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        episodeTitleLabel.text = nil
        podcastLabel.text = nil
        durationLabel.text = nil

        artworkImageView.kf.cancelDownloadTask()
        artworkImageView.image = nil
    }

    func configure(with viewModel: PlaylistCellViewModel) {
        episodeTitleLabel.text = viewModel.title
        podcastLabel.text = viewModel.podcastTitle
        durationLabel.text = viewModel.info
        artworkImageView.kf.setImage(with: viewModel.artworkURL, placeholder: nil, options: [.transition(.fade(0.3))])
    }
}
