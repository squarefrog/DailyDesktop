//
//  Copyright © 2017 Paul Williamson. All rights reserved.
//

import Foundation

/// A list of errors which may be thrown when mapping JSON data to `ImageModel`.
///
/// - invalidData: One of the expected JSON keys is missing, or wrong type.
/// - unableToParseDate: The image date cannot be parsed.
enum BingImageParserError: Error {
    case invalidData(Any?)
    case unableToParseDate(String)
}
