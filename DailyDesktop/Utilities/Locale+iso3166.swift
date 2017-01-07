//
//  Copyright © 2017 Paul Williamson. All rights reserved.
//

import Foundation

extension Locale {
    var iso3166code: String {
        guard
            let language = languageCode,
            let region = regionCode
            else { return "en-US" }
        return "\(language)-\(region)"
    }
}
