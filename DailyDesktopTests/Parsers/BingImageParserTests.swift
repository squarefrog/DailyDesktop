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

        let date = NSDateComponents()
        date.year = 2016
        date.month = 6
        date.day = 29
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        XCTAssertEqual(image.date, calendar?.dateFromComponents(date))

        XCTAssertEqual(image.url.absoluteString, "http://www.bing.com/az/hprichbg/rb/DwarfFlyingSquirrel_EN-GB11302868771_1920x1080.jpg")
        XCTAssertNil(image.title)
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
        let components = NSDateComponents()
        components.year = 2016
        components.month = 7
        components.day = 3
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let date = calendar.dateFromComponents(components)!
        let url = NSURL(string: "http://www.bing.com/image1.jpg")!
        let description = "image 1"
        let webPageURL = NSURL(string: "http://www.bing.com/image1")!

        return ImageModel(date: date,
                          url: url,
                          title: nil,
                          description: description,
                          webPageURL: webPageURL)
    }

    private func secondImage() -> ImageModel {
        let components = NSDateComponents()
        components.year = 2016
        components.month = 7
        components.day = 2
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let date = calendar.dateFromComponents(components)!
        let url = NSURL(string: "http://www.bing.com/image2.jpg")!
        let description = "image 2"
        let webPageURL = NSURL(string: "http://www.bing.com/image2")!

        return ImageModel(date: date,
                          url: url,
                          title: nil,
                          description: description,
                          webPageURL: webPageURL)
    }

    private func thirdImage() -> ImageModel {
        let components = NSDateComponents()
        components.year = 2016
        components.month = 7
        components.day = 1
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let date = calendar.dateFromComponents(components)!
        let url = NSURL(string: "http://www.bing.com/image3.jpg")!
        let description = "image 3"
        let webPageURL = NSURL(string: "http://www.bing.com/image3")!

        return ImageModel(date: date,
                          url: url,
                          title: nil,
                          description: description,
                          webPageURL: webPageURL)
    }

}
