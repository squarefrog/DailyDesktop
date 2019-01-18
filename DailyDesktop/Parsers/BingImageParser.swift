//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

/// A structure which parses JSON returned by Bing into an `ImageModel`.
struct BingImageParser {

    /// Parse `NSData` returned from Bing into an array of `ImageModel` objects.
    ///
    /// - Parameter data: The data returned by Bing.
    /// - Returns: An array of `ImageModel` objects.
    /// - Throws: Can throw if supplied data cannot be serialised into JSON.
    func parseData(_ data: Data) throws -> [ImageModel] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.bing)
        let wrapper = try decoder.decode(ResponseWrapper.self, from: data)
        return wrapper.images
    }
}
