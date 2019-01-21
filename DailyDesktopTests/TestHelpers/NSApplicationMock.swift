//  Copyright © 2019 Paul Williamson. All rights reserved.

import Foundation
@testable import DailyDesktop

class NSApplicationMock: NSObject, Quitable {
    var terminateCalled = false
    var sender: Any?
    func terminate(_ sender: Any?) {
        self.sender = sender
        terminateCalled = true
    }
}
