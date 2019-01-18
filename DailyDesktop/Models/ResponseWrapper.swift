//  Copyright © 2019 Paul Williamson. All rights reserved.

import Foundation

/// A lightweight model for the Bing response JSON
struct ResponseWrapper: Decodable {
    let images: [ImageModel]
}
