//  Copyright © 2019 Paul Williamson. All rights reserved.

import Foundation

/// A date formatter for the dates returned by the Bing API
extension DateFormatter {
    static let bing: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
}
