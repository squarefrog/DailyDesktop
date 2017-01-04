//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

enum Result<T> {
    case success(T)
    case failure(BingProviderError)
}
