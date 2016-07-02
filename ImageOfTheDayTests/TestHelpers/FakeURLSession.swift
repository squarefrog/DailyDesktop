//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

/*
 A mock `NSURLSession` which aids in testing network calls, without ever
 making any real network calls.
 */
class FakeSession: NSURLSession {

    /// The `NSURL` requested during network calls.
    var requestedURL: NSURL?

    var data: NSData?
    var response: NSURLResponse?
    var error: NSError?

    override func dataTaskWithURL(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        requestedURL = url
        completionHandler(data, response, error)
        return NSURLSessionDataTask()
    }
}
