//  Copyright © 2016 Paul Williamson. All rights reserved.

import XCTest
@testable import ImageOfTheDay

class ImageModelTests: XCTestCase {

    func test_ImageModel_ShouldSetPropertyValues() {

        // Given
        let date = NSDate()
        let url = NSURL(string: "http://bing.com")!
        let title = "An image"
        let description = "Some text about the image"
        let webPageURL = NSURL(string: "http://google.com")!

        // When
        let model = ImageModel(date: date,
                               url: url,
                               title: title,
                               description: description,
                               webPageURL: webPageURL)

        // Then
        XCTAssertEqual(model.date, date)
        XCTAssertEqual(model.url, url)
        XCTAssertEqual(model.title, title)
        XCTAssertEqual(model.description, description)
        XCTAssertEqual(model.webPageURL, webPageURL)

    }

}
