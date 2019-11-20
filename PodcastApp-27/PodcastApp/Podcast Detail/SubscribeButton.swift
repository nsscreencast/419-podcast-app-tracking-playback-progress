//
//  SubscribeButton.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 5/22/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

@IBDesignable
class SubscribeButton : UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        commonSetup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonSetup()
    }

    override var isSelected: Bool {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    private var borderColor: UIColor {
        return isSelected ? Theme.Colors.purpleBright : Theme.Colors.purple
    }

    private func commonSetup() {
        tintColor = Theme.Colors.purple
        layer.cornerRadius = 12
        layer.borderWidth = 3
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true

        setTitle("SUBSCRIBE", for: .normal)
        setTitle("SUBSCRIBED", for: .selected)

        let highlightColor = Theme.Colors.purple.withAlphaComponent(0.85)
        setBackgroundImage(UIImage.with(color: highlightColor), for: .highlighted)

        let selectedColor = Theme.Colors.purpleBright
        setBackgroundImage(UIImage.with(color: selectedColor), for: .selected)
        let bundle = Bundle(for: SubscribeButton.self)
        let checkIcon = UIImage(named: "icon-check", in: bundle, compatibleWith: nil)
        setImage(checkIcon, for: .selected)
        setTitleColor(.white, for: .selected)

        imageEdgeInsets.left = -20
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 150, height: 46)
    }
}
