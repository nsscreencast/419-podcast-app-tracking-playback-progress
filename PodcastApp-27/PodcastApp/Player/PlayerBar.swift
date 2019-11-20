//
//  PlayerBar.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 8/28/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

class PlayerBar : UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true

        backgroundColor = .clear        
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        Theme.Colors.gray3.setStroke()

        let lineWidth: CGFloat = 1
        context.setLineWidth(lineWidth)

        let y = rect.height - lineWidth/2
        context.move(to: CGPoint(x: 0, y: y))
        context.addLine(to: CGPoint(x: rect.width, y: y))
        context.strokePath()
    }
}
