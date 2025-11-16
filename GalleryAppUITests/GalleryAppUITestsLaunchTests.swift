//
//  GalleryAppUITestsLaunchTests.swift
//  GalleryAppUITests
//
//  Created by  Apple on 10.11.2025.
//

import XCTest

final class GalleryAppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Wait for the app to be ready
        let exists = NSPredicate(format: "exists == true")
        let window = app.windows.firstMatch
        expectation(for: exists, evaluatedWith: window, handler: nil)
        waitForExpectations(timeout: 5.0, handler: nil)

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
