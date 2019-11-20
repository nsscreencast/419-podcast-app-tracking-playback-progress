//
//  String+HTML.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 7/11/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import Foundation

extension String {
    func htmlAttributedString() -> NSAttributedString {
        do {
            let attrString = try NSAttributedString(data: data(using: .utf8)!,
                                                options: [.documentType : NSAttributedString.DocumentType.html],
                                                documentAttributes: nil)
            return attrString
        } catch {
            return NSAttributedString(string: self)
        }
    }

    func strippingHTML() -> String {
        return replacingOccurrences(of: "<[^>]+>",
                                    with: "",
                                    options: .regularExpression,
                                    range: nil)
    }
}
