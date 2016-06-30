//  Copyright © 2016 Paul Williamson. All rights reserved.

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)

    override func awakeFromNib() {
        statusItem.image = NSImage(named: "MenuIcon")
        statusItem.menu = statusMenu
    }

    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
}
