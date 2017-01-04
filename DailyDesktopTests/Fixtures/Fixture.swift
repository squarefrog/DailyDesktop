//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

enum FixtureError: Error {
    case unknownFile(String)
}

enum Fixture: String {
    class DummyClass { }

    case Bing = "bing"
    case BingMultiple = "bing-multiple"

    func jsonData() throws -> Any {
        let data = try nsData()
        return try JSONSerialization.jsonObject(with: data, options: [])
    }

    func nsData() throws -> Data {
        let bundle = Bundle(for: Fixture.DummyClass.self)
        guard let path = bundle.path(forResource: self.rawValue, ofType: "json") else {
            throw FixtureError.unknownFile("\(self.rawValue).json")
        }
        return FileManager.default.contents(atPath: path)!
    }
}
