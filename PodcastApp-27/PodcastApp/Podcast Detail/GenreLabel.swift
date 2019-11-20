//
//  GenreLabel.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 5/22/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

@IBDesignable
class GenreLabel : UILabel {

    @IBInspectable
    var horizontalInset: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    @IBInspectable
    var verticalInset: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonSetup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonSetup()
    }

    private func commonSetup() {
        backgroundColor = Theme.Colors.gray2
        textColor = Theme.Colors.gray0
        font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textAlignment = .center
        layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height / 2
    }

    override var intrinsicContentSize: CGSize {
        var superSize = super.intrinsicContentSize
        superSize.width += horizontalInset * 2
        superSize.height += verticalInset * 2
        return superSize
    }
}
