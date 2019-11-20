//
//  PodcastFeedLoaderTest.swift
//  PodcastAppTests
//
//  Created by Ben Scheirman on 5/7/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import Foundation
import XCTest
@testable import PodcastApp

class PodcastFeedLoaderTests : XCTestCase {
    func testCanParseFeeds() {
        let feeds = [
            "http://feeds.gimletmedia.com/hearreplyall",
            "http://podcast.armadamusic.com/asot/podcast.xml",
            "https://feeds.publicradio.org/public_feeds/in-the-dark/itunes/rss"
        ].compactMap(URL.init)

        for feed in feeds {
            let exp = expectation(description: "Loading feed \(feed)...")
            let lookup = PodcastLookupInfo(id: UUID().uuidString, feedURL: feed)
            PodcastFeedLoader().fetch(lookupInfo: lookup) { result in
                exp.fulfill()
                switch result {
                case .failure(let e):
                    XCTFail(e.localizedDescription)
                case .success(let podcast):
                    XCTAssertNotNil(podcast.title)
                }
            }
        }
        waitForExpectations(timeout: 10)
    }
}
