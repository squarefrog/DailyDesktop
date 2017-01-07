//
//  Copyright © 2017 Paul Williamson. All rights reserved.
//

import Foundation

/// Image manager errors
///
/// - supportDirectoryNotFound: The Application Support directory was missing.
/// - fileExists: A file already exists with the generated filename.
/// - invalidImageData: Couldn't create an image from data returned by server.
enum ImageManagerError: Error {
    case supportDirectoryNotFound
    case fileExists(URL)
    case invalidImageData
}
