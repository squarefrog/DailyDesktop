//  Created by Paul Williamson on 02/07/2016.

import XCTest
@testable import DailyDesktop

class BingImageParserTests: XCTestCase {
    func test_BingImageParser_CanParseSingleItem() {

        // Given
        let data = try! Fixture.Bing.nsData()

        // When
        let images = try! BingImageParser().parseData(data)

        // Then
        XCTAssertEqual(images.count, 1)
        let image = images.first!

        var date = DateComponents()
        date.year = 2016
        date.month = 6
        date.day = 29
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        XCTAssertEqual(image.date, calendar.date(from: date))

        XCTAssertEqual(image.url.absoluteString, "http://www.bing.com/az/hprichbg/rb/DwarfFlyingSquirrel_EN-GB11302868771_1920x1080.jpg")
        XCTAssertEqual(image.description, "Japanese dwarf flying squirrel in Rishiri-Rebun-Sarobetsu National Park, Japan (© HTB/NHK Video Bank Creative/Getty Images)")
        XCTAssertEqual(image.webPageURL.absoluteString, "http://www.bing.com/search?q=Japanese+dwarf+flying+squirrel&form=hpcapt&filters=HpDate:%2220160629_2300%22")

    }

    func test_BingImageParser_CanParseMultipleItems() {

        // Given
        let data = try! Fixture.BingMultiple.nsData()

        // When
        let images = try! BingImageParser().parseData(data)

        // Then
        XCTAssertEqual(images.count, 3)
        XCTAssertEqual(images[0], firstImage())
        XCTAssertEqual(images[1], secondImage())
        XCTAssertEqual(images[2], thirdImage())

    }

    private func firstImage() -> ImageModel {
        var components = DateComponents()
        components.year = 2016
        components.month = 7
        components.day = 3
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = calendar.date(from: components)!
        let url = URL(string: "http://www.bing.com/image1.jpg")!
        let description = "image 1"
        let webPageURL = URL(string: "http://www.bing.com/image1")!

        return ImageModel(date: date,
                          url: url,
                          description: description,
                          webPageURL: webPageURL)
    }

    private func secondImage() -> ImageModel {
        var components = DateComponents()
        components.year = 2016
        components.month = 7
        components.day = 2
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = calendar.date(from: components)!
        let url = URL(string: "http://www.bing.com/image2.jpg")!
        let description = "image 2"
        let webPageURL = URL(string: "http://www.bing.com/image2")!

        return ImageModel(date: date,
                          url: url,
                          description: description,
                          webPageURL: webPageURL)
    }

    private func thirdImage() -> ImageModel {
        var components = DateComponents()
        components.year = 2016
        components.month = 7
        components.day = 1
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = calendar.date(from: components)!
        let url = URL(string: "http://www.bing.com/image3.jpg")!
        let description = "image 3"
        let webPageURL = URL(string: "http://www.bing.com/image3")!

        return ImageModel(date: date,
                          url: url,
                          description: description,
                          webPageURL: webPageURL)
    }

}
