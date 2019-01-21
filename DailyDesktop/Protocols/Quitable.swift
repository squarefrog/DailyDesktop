//  Copyright © 2019 Paul Williamson. All rights reserved.

import Cocoa

@objc protocol Quitable {
    func terminate(_ sender: Any?)
}

extension NSApplication: Quitable { }
