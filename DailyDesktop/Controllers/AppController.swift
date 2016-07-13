//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

class AppController: NSObject {
    @IBOutlet weak var menuController: StatusMenuController!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension AppController: Updatable {
    func update() {

    }
}
