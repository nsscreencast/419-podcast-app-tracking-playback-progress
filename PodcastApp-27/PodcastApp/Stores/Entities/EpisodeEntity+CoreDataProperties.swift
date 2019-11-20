//
//  EpisodeEntity+CoreDataProperties.swift
//  
//
//  Created by Ben Scheirman on 10/18/19.
//
//

import Foundation
import CoreData


extension EpisodeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EpisodeEntity> {
        return NSFetchRequest<EpisodeEntity>(entityName: "Episode")
    }

    @NSManaged public var identifier: String
    @NSManaged public var duration: Double
    @NSManaged public var episodeDescription: String
    @NSManaged public var title: String
    @NSManaged public var publicationDate: Date
    @NSManaged public var enclosureURL: URL
    @NSManaged public var podcast: PodcastEntity
    @NSManaged public var status: EpisodeStatusEntity?
}
