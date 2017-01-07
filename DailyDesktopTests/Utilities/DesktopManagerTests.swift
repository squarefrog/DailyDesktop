//
//  Copyright © 2017 Paul Williamson. All rights reserved.
//

import XCTest
@testable import DailyDesktop

class DesktopManagerTests: XCTestCase {

    func test_DesktopManager_CanBeInstantiatedWithWorkspaceAndScreens() {

        // Given
        let screen = NSScreen()
        let workspace = NSWorkspaceMock()

        // When
        let manager = DesktopManager(workspace: workspace, screens: [screen])

        // Then
        XCTAssertNotNil(manager)

    }

    func test_DesktopManager_ShouldSetDesktopImageWithURL() {

        // Given
        let screen = NSScreen()
        let workspace = NSWorkspaceMock()
        let manager = DesktopManager(workspace: workspace, screens: [screen])
        let url = URL(fileURLWithPath: "/Users/test/image.jpg")

        do {

            // When
            try manager.setDesktopImage(with: url)

            // Then
            XCTAssertEqual(workspace.imageURL, url)
            XCTAssertEqual(workspace.screens, [screen])

        } catch {

            let message = "\(error)"
            XCTFail(message)

        }

    }

}
