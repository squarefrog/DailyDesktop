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

}
