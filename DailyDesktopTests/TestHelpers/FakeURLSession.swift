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

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        requestedURL = url
        completionHandler(data, response, error)
        return URLSessionDataTask()
    }
}
