//  Copyright © 2016 Paul Williamson. All rights reserved.

import XCTest
@testable import DailyDesktop

class BingProviderTests: XCTestCase {

    var baseURL: URL!
    var fullURL: URL!

    override func setUp() {
        super.setUp()
        var string = "https://www.bing.com/HPImageArchive.aspx?format=js"
        baseURL = URL(string: string)!
        let mkt = NSLocale.current.iso3166code
        string.append("&idx=0&n=1&mkt=\(mkt)")
        fullURL = URL(string: string)!
    }

    func test_BingProvider_CanBeInstantiatedWithASessionConfiguration() {

        // Given
        let session = URLSession.shared

        // When
        let provider = BingProvider(session: session)

        // Then
        XCTAssertEqual(provider.session, session)

    }

    func test_BingProvider_ShouldHaveABaseURL() {

        // Given
        let provider = BingProvider(session: URLSession.shared)

        // When
        let baseURL = provider.baseURL

        // Then
        XCTAssertEqual(baseURL.absoluteString, "https://www.bing.com/HPImageArchive.aspx?format=js")

    }

    func test_BingProvider_WhenFetchingLatestImage_UsesCorrectURL() {

        // Given
        let session = FakeSession()
        XCTAssertNil(session.requestedURL)
        let provider = BingProvider(session: session)

        // When
        provider.fetchLatestImage { _ in }

        // Then
        XCTAssertEqual(session.requestedURL, fullURL)

    }

    func test_BingProvider_WhenFetchingLatestImage_ReturnsData() {

        // Given
        let session = FakeSession()
        session.response = HTTPURLResponse(url: fullURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let jsonData = try! Fixture.bing.nsData()
        session.data = jsonData
        let provider = BingProvider(session: session)
        var returnedData: Data?
        let expectation = self.expectation(description: "Should call completion block")

        // When
        provider.fetchLatestImage { result in
            switch result {
            case .success(let data): returnedData = data
            case .failure: XCTFail("Should not return failure result")
            }
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(returnedData, jsonData as Data)

    }

    func test_BingProvider_WhenFetchingLatestImage_ShouldReturnError() {

        // Given
        let session = FakeSession()
        let error = NSError(domain: "bing.tests", code: 404, userInfo: nil)
        session.error = error
        let provider = BingProvider(session: session)
        var returnedError: BingProviderError?
        let expectation = self.expectation(description: "Should pass error back")

        // When
        provider.fetchLatestImage { result in
            switch result {
            case .success: XCTFail("Should not return success result")
            case .failure(let error): returnedError = error
            }
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(returnedError, BingProviderError.networkError(error))

    }

    func test_BingProvider_WhenFetchingLatestImage_ShouldCreateHTTPError() {

        // Given
        let session = FakeSession()
        session.response = HTTPURLResponse(url: fullURL, statusCode: 404, httpVersion: nil, headerFields: nil)
        let provider = BingProvider(session: session)
        var returnedError: BingProviderError?
        let expectation = self.expectation(description: "Should pass error back")

        // When
        provider.fetchLatestImage { result in
            switch result {
            case .success: XCTFail("Should not return successful result")
            case .failure(let error): returnedError = error
            }
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(returnedError, BingProviderError.httpCode(404))

    }

    func test_BingProvider_WhenFetchingLatestImage_ShouldCreateEmptyResponseError() {

        // Given
        let session = FakeSession()
        let provider = BingProvider(session: session)
        var returnedError: BingProviderError?
        let expectation = self.expectation(description: "Should pass error back")

        // When
        provider.fetchLatestImage { result in
            switch result {
            case .success: XCTFail("Should not return successful result")
            case .failure(let error): returnedError = error
            }
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(returnedError, BingProviderError.emptyResponse)

    }

    func test_BingProvider_WhenFetchingLatestImage_ShouldCreateEmptyDataError() {

        // Given
        let session = FakeSession()
        session.response = HTTPURLResponse(url: fullURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let provider = BingProvider(session: session)
        var returnedError: BingProviderError?
        let expectation = self.expectation(description: "Should pass error back")

        // When
        provider.fetchLatestImage { result in
            switch result {
            case .success: XCTFail("Should not return successful result")
            case .failure(let error): returnedError = error
            }
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(returnedError, BingProviderError.emptyData)

    }

    func test_BingProvider_WhenFetchingLatestImage_CallsResume() {

        // Given
        let session = FakeSession()
        let provider = BingProvider(session: session)

        // When
        provider.fetchLatestImage { _ in }

        // Then
        guard let task = session.dataTask else { return XCTFail("Should have valid session data task") }
        XCTAssertTrue(task.resumeCalled)

    }

    func test_BingProvider_ShouldAllowFetchingMultipleImages() {

        // Given
        let session = FakeSession()
        XCTAssertNil(session.requestedURL)
        let provider = BingProvider(session: session)
        let urlString = fullURL.absoluteString.replacingOccurrences(of: "n=1", with: "n=3")
        let imageURL = URL(string: urlString)!

        // When
        provider.fetchLatestImages(count: 3) { _ in }

        // Then
        XCTAssertEqual(session.requestedURL, imageURL)

    }

    func test_BingProvider_WhenDownloadingImage_UsesCorrectURL() {

        // Given
        let url = URL(string: "https://www.bing.com/image.jpg")!
        let webUrl = URL(string: "https://www.bing.com")!
        let model = ImageModel(date: Date(),
                               url: url,
                               description: "",
                               webPageURL: webUrl)
        let session = FakeSession()
        let provider = BingProvider(session: session)

        // When
        provider.download(image: model) { _ in }

        // Then
        XCTAssertEqual(session.requestedURL, model.url)

    }

    func test_BingProvider_WhenDownloadingImage_PassesData() {

        // Given
        let url = URL(string: "https://www.bing.com/image.jpg")!
        let webUrl = URL(string: "https://www.bing.com")!
        let model = ImageModel(date: Date(),
                               url: url,
                               description: "",
                               webPageURL: webUrl)
        let session = FakeSession()
        session.response = HTTPURLResponse(url: fullURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = Data()
        session.data = data
        let provider = BingProvider(session: session)
        var returnedData: Data?
        let expectation = self.expectation(description: "Should call completion block")

        // When
        provider.download(image: model) { result in
            switch result {
            case .success(let data): returnedData = data
            case .failure: XCTFail("Should not return failure result")
            }
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(returnedData, data)

    }

    func test_BingProvider_WhenDownloadingImage_CallsResume() {

        // Given
        let url = URL(string: "https://www.bing.com/image.jpg")!
        let webUrl = URL(string: "https://www.bing.com")!
        let model = ImageModel(date: Date(),
                               url: url,
                               description: "",
                               webPageURL: webUrl)
        let session = FakeSession()
        let provider = BingProvider(session: session)

        // When
        provider.download(image: model) { _ in }

        // Then
        guard let task = session.dataTask else { return XCTFail("Should have session dataTask") }
        XCTAssertTrue(task.resumeCalled)

    }
}
