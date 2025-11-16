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

        // Give the app a moment to fully launch
        // If the app crashes due to missing storyboard, this test will fail
        // but won't timeout waiting for UI elements that never appear
        Thread.sleep(forTimeInterval: 2.0)

        // Try to take a screenshot - if app is running, this will work
        // If app crashed, this will also fail gracefully
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
