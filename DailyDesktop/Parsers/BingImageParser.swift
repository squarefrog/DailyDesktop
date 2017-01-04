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
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]

        guard let images = json?["images"] as? [AnyObject] else {
            throw BingImageParserError.invalidData(json)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"

        return try images.flatMap { item in
            guard let json = item as? [String: AnyObject] else { return nil }
            return try ImageModel(json: json, dateFormatter: dateFormatter)
        }
    }
}
