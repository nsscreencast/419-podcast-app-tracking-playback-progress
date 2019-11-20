//
//  NotificationTests.swift
//  PodcastAppTests
//
//  Created by Ben Scheirman on 9/26/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import Foundation
import XCTest
@testable import PodcastApp

extension Notification.Name {
    static var subscriptionChanged = Notification.Name(rawValue: "subscriptionChanged")
}

class NotificationExample {
    var observer: NSObjectProtocol?

    func demo() {
        // block
        observer = NotificationCenter.default.addObserver(forName: .subscriptionChanged,
                                                          object: nil,
                                                          queue: .main) { notification in
                                                            print("Subscriptions changed")
        }

        // selector
        NotificationCenter.default.addObserver(self, selector: #selector(onSubscriptionChanged(_:)),
                                               name: .subscriptionChanged, object: nil)


        // sending?
        NotificationCenter.default.post(name: .subscriptionChanged, object: self, userInfo: [
            "subscribed" : [142]
        ])
    }

    @objc
    private func onSubscriptionChanged(_ notification: Notification) {
        dump(notification.userInfo)
    }
}


class NotificationTests : XCTestCase {
    func testSimpleNotification() {
        let example = NotificationExample()
        example.demo()
    }

    func testTypedNotification() {

        struct SubscriptionsChanged : TypedNotification {
            var sender: Any
            static var name = "subscriptionsChanged"

            var subscribed: Set<Int> = []
            var unsusbscribed: Set<Int> = []
        }

        _ = NotificationCenter.default.addObserver(SubscriptionsChanged.self, sender: self, queue: nil) { notification in
            print("Subscribed to: ", notification.subscribed)
            print("Unsubscribed from: ", notification.unsusbscribed)
        }

        NotificationCenter.default.post(SubscriptionsChanged(sender: self, subscribed: [123], unsusbscribed: [567]))
    }
}
