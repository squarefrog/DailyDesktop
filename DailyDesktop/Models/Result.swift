//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

/// The result of a network call.
enum Result<T> {
    case success(T)
    case failure(BingProviderError)
}
