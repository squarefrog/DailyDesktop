//
//  Copyright © 2017 Paul Williamson. All rights reserved.
//

import AppKit

class NSWorkspaceMock: NSWorkspace {
    var imageURL: URL?
    var screens: [NSScreen] = []
    override func setDesktopImageURL(_ url: URL, for screen: NSScreen, options: [String : Any] = [:]) throws {
        self.imageURL = url
        self.screens.append(screen)
    }
}
