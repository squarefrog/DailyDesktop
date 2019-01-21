//  Copyright © 2016 Paul Williamson. All rights reserved.

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var updateMenuItem: NSMenuItem!
    @IBOutlet weak var lastUpdatedMenuItem: NSMenuItem!
    @IBOutlet weak var updateDelegate: Updatable!
    var application: Quitable = NSApplication.shared

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    override func awakeFromNib() {
        super.awakeFromNib()
        statusItem.image = NSImage(named: "MenuIcon")
        statusItem.menu = statusMenu
        lastUpdatedMenuItem.title = "Last updated: never"
    }

    @IBAction func updateClicked(_ sender: AnyObject) {
        updateDelegate.update()
    }

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        application.terminate(self)
    }
}
