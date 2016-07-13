//  Copyright © 2016 Paul Williamson. All rights reserved.

import XCTest
@testable import DailyDesktop

class MockUpdater: NSObject, Updatable {
    var updateCalled = false
    func update() {
        updateCalled = true
    }
}

class StatusMenuControllerTests: XCTestCase {
    func test_StatusMenuController_ShouldForwardUpdateClicks() {

        // Given
        let menuController = StatusMenuController()
        let mockUpdateDelegate = MockUpdater()
        menuController.updateDelegate = mockUpdateDelegate
        let item = NSMenuItem()

        // When
        menuController.updateClicked(item)

        // Then
        XCTAssertTrue(mockUpdateDelegate.updateCalled)

    }
}
