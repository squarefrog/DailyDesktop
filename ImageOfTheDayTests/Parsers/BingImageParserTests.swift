//  Created by Paul Williamson on 02/07/2016.

import XCTest
@testable import ImageOfTheDay

class BingImageParserTests: XCTestCase {
    func test_BingImageParser_CanParseData() {

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
}
