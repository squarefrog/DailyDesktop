//  Copyright © 2016 Paul Williamson. All rights reserved.

import XCTest
@testable import ImageOfTheDay

class BingProviderTests: XCTestCase {

    let imageURL = NSURL(string: "http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1")!

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

    func test_BingProvider_WhenFetchingLatestImage_UsesCorrectURL() {

        // Given
        let session = FakeSession()
        XCTAssertNil(session.requestedURL)
        let provider = BingProvider(withSession: session)

        // When
        provider.fetchLatestImage { _ in }

        // Then
        XCTAssertEqual(session.requestedURL, imageURL)

    }

    func test_BingProvider_WhenFetchingLatestImage_ReturnsData() {

        // Given
        let session = FakeSession()
        session.response = NSHTTPURLResponse(URL: imageURL, statusCode: 200, HTTPVersion: nil, headerFields: nil)
        let jsonData = try! Fixture.Bing.nsData()
        session.data = jsonData
        let provider = BingProvider(withSession: session)
        var returnedData: NSData?
        let expectation = expectationWithDescription("Should call completion block")

        // When
        provider.fetchLatestImage { result in
            switch result {
            case .Success(let d): returnedData = d
            case .Failure: XCTFail()
            }
            expectation.fulfill()
        }

        // Then
        waitForExpectationsWithTimeout(1.0, handler: nil)
        XCTAssertEqual(returnedData, jsonData)

    }

    func test_BingProvider_WhenFetchingLatestImage_ShouldReturnError() {

        // Given
        let session = FakeSession()
        let error = NSError(domain: "bing.tests", code: 404, userInfo: nil)
        session.error = error
        let provider = BingProvider(withSession: session)
        var returnedError: NSError?
        let expectation = expectationWithDescription("Should pass error back")

        // When
        provider.fetchLatestImage { result in
            switch result {
            case .Success: XCTFail()
            case .Failure(let e): returnedError = e
            }
            expectation.fulfill()
        }

        // Then
        waitForExpectationsWithTimeout(1.0, handler: nil)
        XCTAssertEqual(returnedError, error)

    }

    func test_BingProvider_WhenFetchingLatestImage_ShouldCreateHTTPError() {

        // Given
        let session = FakeSession()
        session.response = NSHTTPURLResponse(URL: imageURL, statusCode: 404, HTTPVersion: nil, headerFields: nil)
        let provider = BingProvider(withSession: session)
        var returnedError: NSError?
        let expectation = expectationWithDescription("Should pass error back")

        // When
        provider.fetchLatestImage { result in
            switch result {
            case .Success: XCTFail()
            case .Failure(let e): returnedError = e
            }
            expectation.fulfill()
        }

        // Then
        waitForExpectationsWithTimeout(1.0, handler: nil)
        XCTAssertEqual(returnedError, Error(errorCode: .HTTPCode(404)))

    }

}
