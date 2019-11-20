//
//  SeparatorView.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 5/22/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

@IBDesignable
class SeparatorView : UIView {

    @IBInspectable
    var separatorColor: UIColor = Theme.Colors.gray3 {
        didSet {
            setNeedsDisplay()
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
        isOpaque = false
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        separatorColor.setStroke()

        context.setLineWidth(1/UIScreen.main.scale)
        let midY = bounds.size.height / 2
        context.move(to: CGPoint(x: 0, y: midY))
        context.addLine(to: CGPoint(x: bounds.size.width, y: midY))
        context.strokePath()
    }
}
