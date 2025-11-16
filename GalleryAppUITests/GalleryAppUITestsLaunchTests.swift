//
//  GalleryAppUITestsLaunchTests.swift
//  GalleryAppUITests
//
//  Created by  Apple on 10.11.2025.
//

import XCTest

final class GalleryAppUITestsLaunchTests: XCTestCase {

    override static var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Wait for the app to be ready - wait for any element to appear
        // This ensures the UI is loaded before taking a screenshot
        let firstElement = app.otherElements.firstMatch
        XCTAssertTrue(firstElement.waitForExistence(timeout: 10.0), "App did not launch in time")

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
