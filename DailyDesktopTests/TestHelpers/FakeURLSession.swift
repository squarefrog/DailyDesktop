//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

/*
 A mock `NSURLSession` which aids in testing network calls, without ever
 making any real network calls.
 */
class FakeSession: URLSession {

    /// The `NSURL` requested during network calls.
    var requestedURL: URL?

    var data: Data?
    var response: URLResponse?
    var error: Error?

    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        requestedURL = url
        completionHandler(data, response, error)
        return URLSessionDataTask()
    }
}
