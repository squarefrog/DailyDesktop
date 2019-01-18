//
//  Copyright © 2017 Paul Williamson. All rights reserved.
//

import AppKit

class FileManagerMock: FileManager {
    var mockURLs: [URL] = []
    var directoryURL: URL?
    var fileShouldExist = false
    var preventCreateDirectory = true // Prevent actual file system modification
    override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        return mockURLs
    }

    override func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]? = nil) throws {
        directoryURL = url
        guard !preventCreateDirectory else { return }
        try super.createDirectory(at: url,
                                  withIntermediateDirectories: createIntermediates,
                                  attributes: attributes)
    }

    override func fileExists(atPath path: String) -> Bool {
        return fileShouldExist
    }
}
