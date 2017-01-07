//
//  Copyright © 2017 Paul Williamson. All rights reserved.
//

import AppKit

struct DesktopManager {
    private let workspace: NSWorkspace
    private let screens: [NSScreen]

    /// Initialise with options
    ///
    /// - Parameters:
    ///   - workspace: The workspace to use, usually `NSWorkspace.shared()`
    ///   - screens: The screens to use, usually `NSScreen.screens()`
    init(workspace: NSWorkspace, screens: [NSScreen]) {
        self.workspace = workspace
        self.screens = screens
    }

    /// Update the desktop image for all screens supplied during initialisation
    ///
    /// - Parameter url: The URL of the image to use
    /// - Throws: If the workspace was unable to set desktop image
    func setDesktopImage(with url: URL) throws {
        for screen in screens {
            try workspace.setDesktopImageURL(url, for: screen, options: [:])
        }
    }
}
