//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

/**
 *  A model representing a generic remote image object.
 */
struct ImageModel {

    /// The date the image was posted.
    let date: Date

    /// The location URL of the image.
    let url: URL

    /// An optional title for the image.
    let title: String?

    /// A text description of the image.
    let description: String

    /// A link to the web page containing the image.
    let webPageURL: URL

}

extension ImageModel: Equatable { }

func ==(lhs: ImageModel, rhs: ImageModel) -> Bool {
    return lhs.date == rhs.date &&
        lhs.url == rhs.url &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.webPageURL == rhs.webPageURL
}
