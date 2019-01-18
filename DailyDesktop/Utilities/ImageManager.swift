//
//  Copyright © 2017 Paul Williamson. All rights reserved.
//

import Foundation
import AppKit

/// A structure responsible for persisting downloaded images to disk
struct ImageManager {

    private let fileManager: FileManager
    private let directory: URL
    private let formatter: DateFormatter

    /// Create a new image manager
    ///
    /// - Parameters:
    ///   - fileManager: File manager used when creating Application Support folder
    ///   - bundleIdentifier: Bundle identifier appended to application support path
    /// - Throws: ImageManagerError when Application Support folder missing
    init(fileManager: FileManager, bundleIdentifier: String) throws {
        self.directory = try ImageManager.applicationDirectory(fileManager: fileManager,
                                                               bundleIdentifier: bundleIdentifier)
        self.fileManager = fileManager
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.formatter = formatter
    }

    /// Store image data
    ///
    /// - Parameters:
    ///   - data: The image data returned by Bing
    ///   - model: The image model that describes the image
    /// - Returns: The path the image was written to
    /// - Throws: ImageManagerError if file already exists, or is invalid data
    func store(data: Data, model: ImageModel) throws -> URL {
        let filename = formatter.string(from: model.date)
        let url = directory.appendingPathComponent("\(filename).jpg")

        guard !fileManager.fileExists(atPath: url.path) else {
            throw ImageManagerError.fileExists(url)
        }

        guard NSImage(data: data) != nil else {
            throw ImageManagerError.invalidImageData
        }

        try data.write(to: url)
        return url
    }

    private static func applicationDirectory(fileManager: FileManager, bundleIdentifier: String) throws -> URL {
        let supportDir = fileManager.urls(for: .applicationSupportDirectory,
                                          in: .userDomainMask)

        guard !supportDir.isEmpty else {
            throw ImageManagerError.supportDirectoryNotFound
        }

        let dirPath = supportDir[0].appendingPathComponent(bundleIdentifier)
        try fileManager.createDirectory(at: dirPath,
                                        withIntermediateDirectories: true,
                                        attributes: nil)

        return dirPath
    }
}
