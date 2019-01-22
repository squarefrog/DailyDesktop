//  Copyright © 2016 Paul Williamson. All rights reserved.

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var updateMenuItem: NSMenuItem!
    @IBOutlet weak var lastUpdatedMenuItem: NSMenuItem!
    @IBOutlet weak var copyrightMenuItem: NSMenuItem!
    @IBOutlet weak var updateDelegate: Updatable!

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var application: Quitable = NSApplication.shared

    override func awakeFromNib() {
        super.awakeFromNib()
        statusItem.image = NSImage(named: "MenuIcon")
        statusItem.menu = statusMenu
    }

    @IBAction func updateClicked(_ sender: AnyObject) {
        updateDelegate.update()
    }

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        application.terminate(self)
    }

    func setLastUpdatedText(_ text: String?) {
        let time = text ?? "never"
        lastUpdatedMenuItem.title = "Last updated: \(time)"
    }

    func setCopyrightText(_ text: String) {
        copyrightMenuItem.isHidden = false
        copyrightMenuItem.title = text
    }
}
