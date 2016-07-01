//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

/**
 *  A networking provider for working with the Bing image of the day API.
 */
struct BingProvider {

    /// The `NSURLSession` to perform network requests through.
    let session: NSURLSession

    /**
     An initialiser which takes in an `NSURLSession`, and returns a new instance
     of a `BingProvider`.
     */
    init(withSession session: NSURLSession) {
        self.session = session
    }

}
