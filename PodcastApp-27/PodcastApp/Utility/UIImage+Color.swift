//
//  UIImage+Color.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 5/22/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

extension UIImage {
    static func with(color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    func tint(color: UIColor) -> UIImage {
        let maskImage = cgImage
        let bounds = CGRect(origin: .zero, size: size)

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let cgContext = context.cgContext
            cgContext.clip(to: bounds, mask: maskImage!)
            color.setFill()
            cgContext.fill(bounds)
        }
    }
}
