//
//  EpisodeCell.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 7/16/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = Theme.Colors.gray5
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = Theme.Colors.gray4
        contentView.backgroundColor = Theme.Colors.gray5
        titleLabel.textColor = Theme.Colors.gray0
        infoLabel.textColor = Theme.Colors.gray2
        descriptionLabel.textColor = Theme.Colors.gray2
    }

    func configure(with viewModel: EpisodeCellViewModel) {
        titleLabel.text = viewModel.title
        infoLabel.text = viewModel.info
        descriptionLabel.text = viewModel.description
    }
}
