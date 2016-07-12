//  Copyright © 2016 Paul Williamson. All rights reserved.

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var updateMenuItem: NSMenuItem!
    @IBOutlet weak var lastUpdatedMenuItem: NSMenuItem!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)

    override func awakeFromNib() {
        statusItem.image = NSImage(named: "MenuIcon")
        statusItem.menu = statusMenu
        lastUpdatedMenuItem.title = "Last updated: never"
    }

    @IBAction func updateClicked(sender: AnyObject) {
    }

    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
}
