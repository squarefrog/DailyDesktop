//
//  Copyright © 2017 Paul Williamson. All rights reserved.
//

import XCTest

@testable import DailyDesktop

class ImageManagerTests: XCTestCase {

    let bundleIdentifier = "DailyDesktopTests"
    var imageModel: ImageModel!
    var fileManager: FileManagerMock!
    var tempDir: URL?
    var bundleDir: URL?
    var fileURL: URL?

    override func setUp() {
        super.setUp()
        imageModel = setupImageModel()
        tempDir = setupTemporaryDirectory()
        bundleDir = tempDir?.appendingPathComponent(bundleIdentifier)
        fileURL = bundleDir?.appendingPathComponent("2017-01-31.jpg")
        fileManager = setupFileManager()
    }

    override func tearDown() {
        super.tearDown()

        // Remove temporary directory
        guard let path = tempDir else { return }
        try? FileManager.default.removeItem(at: path)
    }

    func test_ImageManager_WhenInitialising_CanBeInstantiatedWithFileManager() {

        // Given

        // When
        let manager = try? ImageManager(fileManager: fileManager,
                                        bundleIdentifier: bundleIdentifier)

        // Then
        XCTAssertNotNil(manager)

    }

    func test_ImageManager_WhenInitialising_CreatesDirectoryWithBundleIdentifier() {

        // Given
        guard let bundleDir = bundleDir else { return XCTFail("No temp dir") }

        // When
        let _ = try? ImageManager(fileManager: fileManager,
                                  bundleIdentifier: bundleIdentifier)

        // Then
        XCTAssertEqual(fileManager.directoryURL, bundleDir)

    }

    func test_ImageManager_WhenInitialising_ThrowsIfApplicationSupportDirectoryMissing() {

        // Given
        fileManager.mockURLs = []

        do {

            // When
            let _ = try ImageManager(fileManager: fileManager,
                                     bundleIdentifier: bundleIdentifier)

        } catch ImageManagerError.supportDirectoryNotFound {

            // Then
            XCTAssert(true)

        } catch {

            let message = "\(error)"
            XCTFail(message)

        }

    }

    func test_ImageManager_WhenStoringImage_WritesData() {

        // Given
        guard let url = tempDir else { return XCTFail("No temp dir") }
        fileManager.preventCreateDirectory = false
        let manager = try? ImageManager(fileManager: fileManager,
                                        bundleIdentifier: bundleIdentifier)

        do {

            // When
            guard let data = loadTestImageData() else { return XCTFail() }
            let _ = try manager?.store(data: data, model: imageModel)

            // Then
            let realFileManager = FileManager.default
            let fileURL = url.appendingPathComponent("DailyDesktopTests/2017-01-31.jpg")
            XCTAssertTrue(realFileManager.fileExists(atPath: fileURL.path))
            try? realFileManager.removeItem(at: fileURL)

        } catch {

            let message = "\(error)"
            XCTFail(message)

        }

    }

    func test_ImageManager_WhenStoringImage_ReturnsImagePath() {

        // Given
        guard let data = loadTestImageData() else { return XCTFail("Unable to load test image") }
        guard let fileURL = fileURL else { return XCTFail("No file path") }
        fileManager.preventCreateDirectory = false
        let manager = try? ImageManager(fileManager: fileManager,
                                        bundleIdentifier: bundleIdentifier)

        do {

            // When
            let returnedURL = try manager?.store(data: data, model: imageModel)

            // Then
            XCTAssertEqual(returnedURL?.path, fileURL.path)

        } catch {

            let message = "\(error)"
            XCTFail(message)

        }

    }

    func test_ImageManager_WhenStoringImage_ThrowsIfFileExists() {

        // Given
        guard let fileURL = fileURL else { return XCTFail("No file path") }
        fileManager.fileShouldExist = true
        let manager = try? ImageManager(fileManager: fileManager,
                                        bundleIdentifier: bundleIdentifier)

        do {

            // When
            let _ = try manager?.store(data: Data(), model: imageModel)

        } catch ImageManagerError.fileExists(let url) {

            // Then
            XCTAssertEqual(url.path, fileURL.path)

        } catch {

            let message = "\(error)"
            XCTFail(message)

        }

    }

    func test_ImageManager_WhenStoringImage_ThrowsIfNotAnImage() {

        // Given
        let manager = try? ImageManager(fileManager: fileManager,
                                        bundleIdentifier: bundleIdentifier)

        do {

            // When
            let _ = try manager?.store(data: Data(), model: imageModel)

        } catch ImageManagerError.invalidImageData {

            // Then
            XCTAssert(true)

        } catch {

            let message = "\(error)"
            XCTFail(message)

        }

    }

}

extension ImageManagerTests {

    /// Create an image model to use when testing
    func setupImageModel() -> ImageModel {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: "2017-01-31")!
        let url = URL(string: "http://bing.com")!

        return ImageModel(date: date,
                          url: url,
                          title: nil,
                          description: "",
                          webPageURL: url)
    }

    /// Setup a temporary directory to use while testing
    func setupTemporaryDirectory() -> URL? {
        let folder = "uk.co.squarefrog.dailydesktoptests"
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory())
        let directory = tempDir.appendingPathComponent(folder, isDirectory: true)
        do {
            let fileManager = FileManager.default
            try fileManager.createDirectory(at: directory,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
           return directory
        } catch {
            print(error)
            return nil
        }
    }

    /// Setup a mock of FileManager to prevent writing to disk unless required
    func setupFileManager() -> FileManagerMock {
        let fileManager = FileManagerMock()
        var urls: [URL] = []
        if let tempDir = tempDir { urls.append(tempDir) }
        fileManager.mockURLs = urls
        return fileManager
    }

    /// Create a Data object from a test image
    func loadTestImageData() -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.urlForImageResource("TestImage.jpg") else { return nil }
        return try? Data(contentsOf: url)
    }
}
