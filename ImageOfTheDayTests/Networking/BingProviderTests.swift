//  Copyright © 2016 Paul Williamson. All rights reserved.

import XCTest
@testable import ImageOfTheDay

class BingProviderTests: XCTestCase {

    func test_BingProvider_CanBeInstantiatedWithASessionConfiguration() {

        // Given
        let session = NSURLSession.sharedSession()

        // When
        let provider = BingProvider(withSession: session)

        // Then
        XCTAssertEqual(provider.session, session)

    }

    func test_BingProvider_ShouldHaveABaseURL() {

        // Given
        let provider = BingProvider(withSession: NSURLSession.sharedSession())

        // When
        let baseURL = provider.baseURL

        // Then
        XCTAssertEqual(baseURL.absoluteString, "http://www.bing.com/HPImageArchive.aspx?format=js")

    }

}
