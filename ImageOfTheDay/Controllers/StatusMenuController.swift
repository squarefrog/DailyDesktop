//  Copyright © 2016 Paul Williamson. All rights reserved.

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var updateMenuItem: NSMenuItem!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)

    override func awakeFromNib() {
        statusItem.image = NSImage(named: "MenuIcon")
        statusItem.menu = statusMenu
    }

    @IBAction func updateClicked(sender: AnyObject) {
    }

    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
}
