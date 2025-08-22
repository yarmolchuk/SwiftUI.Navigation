//
//  SwiftUI_NavigationUITestsLaunchTests.swift
//  SwiftUI.NavigationUITests
//
//  Created by Dmytro Yarmolchuk on 11.08.2025.
//

import XCTest

final class SwiftUI_NavigationUITestsLaunchTests: XCTestCase {

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

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
