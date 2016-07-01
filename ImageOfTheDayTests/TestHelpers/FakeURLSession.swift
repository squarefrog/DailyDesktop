//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

/*
 A mock `NSURLSession` which aids in testing network calls, without ever
 making any real network calls.
 */
class FakeSession: NSURLSession {

    /// The `NSURL` requested during network calls.
    var requestedURL: NSURL?

    override func dataTaskWithURL(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        requestedURL = url
        return NSURLSessionDataTask()
    }
}
