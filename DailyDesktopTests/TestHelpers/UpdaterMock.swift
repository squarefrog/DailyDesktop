//  Copyright © 2019 Paul Williamson. All rights reserved.

import Foundation
@testable import DailyDesktop

class UpdaterMock: NSObject, Updatable {
    var updateCalled = false
    func update() {
        updateCalled = true
    }
}
