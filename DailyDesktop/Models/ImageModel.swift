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

extension ImageModel: Decodable {

    enum CodingKeys: String, CodingKey {
        case date = "startdate"
        case url = "url"
        case copyright
        case copyrightLink = "copyrightlink"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        date = try container.decode(Date.self, forKey: .date)
        description = try container.decode(String.self, forKey: .copyright)
        webPageURL = try container.decode(URL.self, forKey: .copyrightLink)

        let baseURL = URL(string: "https://www.bing.com")!
        let path = try container.decode(String.self, forKey: .url)
        url = baseURL.appendingPathComponent(path)
    }

}

extension ImageModel: Equatable { }

func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
    return lhs.date == rhs.date &&
        lhs.url == rhs.url &&
        lhs.description == rhs.description &&
        lhs.webPageURL == rhs.webPageURL
}
