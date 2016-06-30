//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

enum FixtureError: ErrorType {
    case UnknownFile(String)
}

enum Fixture: String {
    class DummyClass { }

    case Bing = "bing"

    func jsonData() throws -> AnyObject {
        let bundle = NSBundle(forClass: Fixture.DummyClass.self)
        guard let path = bundle.pathForResource(self.rawValue, ofType: "json") else {
            throw FixtureError.UnknownFile("\(self.rawValue).json")
        }
        let data = NSFileManager.defaultManager().contentsAtPath(path)!
        return try NSJSONSerialization.JSONObjectWithData(data, options: [ ])
    }
}
