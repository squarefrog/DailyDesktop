//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

struct BingImageParser {

    func parseData(data: NSData) throws -> [ImageModel] {
        let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        guard
            let images = json["images"] as? [AnyObject],
            let image = images.first as? [String: AnyObject],
            let startDate = image["startdate"] as? String,
            let urlPath = image["url"] as? String,
            let description = image["copyright"] as? String,
            let copyrightLink = image["copyrightlink"] as? String
            else { return [] }

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        guard let date = dateFormatter.dateFromString(startDate) else { return [] }

        guard let url = NSURL(string: "http://www.bing.com\(urlPath)") else { return [] }

        guard let webPageURL = NSURL(string: copyrightLink) else { return [] }

        return [
            ImageModel(date: date,
                url: url,
                title: nil,
                description: description,
                webPageURL: webPageURL)
        ]

    }
}
