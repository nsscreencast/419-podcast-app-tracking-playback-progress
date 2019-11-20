//
//  SubscriptionsChanged.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 10/2/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import Foundation

struct SubscriptionsChanged : TypedNotification {
    var sender: Any?

    static var name: String = "SubscriptionsChangedNotification"

    let subscribedIds: Set<String>
    let unsubscribedIds: Set<String>

    init(subscribed: Set<String>) {
        subscribedIds = subscribed
        unsubscribedIds = []
    }

    init(unsubscribed: Set<String>) {
        subscribedIds = []
        unsubscribedIds = unsubscribed
    }
}
