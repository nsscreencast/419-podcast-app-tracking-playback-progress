//
//  PodcastEntity+CoreDataClass.swift
//  
//
//  Created by Ben Scheirman on 7/26/19.
//
//

import Foundation
import CoreData

@objc(PodcastEntity)
public class PodcastEntity: NSManagedObject {
    var artworkURL: URL? {
        return artworkURLString.flatMap(URL.init)        
    }

    var lookupInfo: PodcastLookupInfo? {
        guard let id = id else { return nil }
        guard let feedURL = feedURLString.flatMap(URL.init) else { return nil }
        return PodcastLookupInfo(id: id, feedURL: feedURL)
    }

}

extension PodcastEntity : PodcastCellModel {
    var titleText: String? { return title }
    var authorText: String? { return author }
    var artwork: URL? { return artworkURL }
}
