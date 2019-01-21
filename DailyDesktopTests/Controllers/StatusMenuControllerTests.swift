//  Copyright © 2016 Paul Williamson. All rights reserved.

import XCTest
@testable import DailyDesktop

class StatusMenuControllerTests: XCTestCase {
    func test_StatusMenuController_ShouldForwardUpdateClicks() {

        // Given
        let menuController = StatusMenuController()
        let mockUpdateDelegate = UpdaterMock()
        menuController.updateDelegate = mockUpdateDelegate
        let item = NSMenuItem()

        // When
        menuController.updateClicked(item)

        // Then
        XCTAssertTrue(mockUpdateDelegate.updateCalled)

    }

    func test_StatusMenuController_ApplicationShouldNotBeNil() {

        // Given
        let menuController = StatusMenuController()

        // When
        let application = menuController.application as? NSApplication

        // Then
        XCTAssertEqual(application, NSApplication.shared)

    }

    func test_StatusMenuController_WhenQuitting_ShouldCallTerminate() {

        // Given
        let menuController = StatusMenuController()
        let mockApplication = NSApplicationMock()
        menuController.application = mockApplication
        let item = NSMenuItem()

        // When
        menuController.quitClicked(item)

        // Then
        XCTAssertTrue(mockApplication.terminateCalled)

    }

    func test_StatusMenuController_WhenQuitting_ShouldPassSelf() {

        // Given
        let menuController = StatusMenuController()
        let mockApplication = NSApplicationMock()
        menuController.application = mockApplication
        let item = NSMenuItem()

        // When
        menuController.quitClicked(item)

        guard let expected = mockApplication.sender as? StatusMenuController else {
            XCTFail("StatusMenuController should pass self when quitting")
            return
        }

        // Then
        XCTAssertEqual(menuController, expected)

    }
}
