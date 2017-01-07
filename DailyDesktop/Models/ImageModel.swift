//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

/// A model representing a generic remote image object.
struct ImageModel {

    /// The date the image was posted.
    let date: Date

    /// The location URL of the image.
    let url: URL

    /// A text description of the image.
    let description: String

    /// A link to the web page containing the image.
    let webPageURL: URL

}

extension ImageModel {
    /// Initialise an ImageModel from JSON returned by Bing API
    init?(json: [String: AnyObject], dateFormatter: DateFormatter) throws {
        guard
            let startDate = json["startdate"] as? String,
            let urlPath = json["url"] as? String,
            let description = json["copyright"] as? String,
            let copyrightLink = json["copyrightlink"] as? String,
            let url = URL(string: "http://www.bing.com\(urlPath)"),
            let webPageURL = URL(string: copyrightLink)
            else {
                throw BingImageParserError.invalidData(json as AnyObject)
        }

        guard let date = dateFormatter.date(from: startDate) else {
            throw BingImageParserError.unableToParseDate(startDate)
        }

        self.date = date
        self.url = url
        self.description = description
        self.webPageURL = webPageURL
    }
}

extension ImageModel: Equatable { }

func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
    return lhs.date == rhs.date &&
        lhs.url == rhs.url &&
        lhs.description == rhs.description &&
        lhs.webPageURL == rhs.webPageURL
}
