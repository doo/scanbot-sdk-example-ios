//
//  ScanbotSDKDemoUITests.swift
//  ScanbotSDKDemoUITests
//
//  Created by Yevgeniy Knizhnik on 23.11.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import XCTest

class ScanbotSDKDemoUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testMainUI() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        
        addUIInterruptionMonitor(withDescription: "Camera allowance") { (alert) -> Bool in
            alert.buttons["OK"].tap()
            return true
        }

        tablesQuery.cells.staticTexts["Document Scanner Demo"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["Document Scanner Aspect Ratio Demo"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["Payform Scanner Demo"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["Cheque Demo"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["Machine Readable Zones Demo"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["Disability Certificates Demo"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        ///
        tablesQuery.cells.staticTexts["Disability Certificates Live Demo"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["NFC Passport Reader"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["Europian Health Insurance Card Demo"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["TIFF Demo"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["Business Cards Demo"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["Barcode Scanner Demo"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["Barcode Scanner Demo with Finder View"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["Adjustable filters demo"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["Blurriness Estimator Demo"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["Text Line Recognizer Demo"].tap()
        _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 1)
        app.navigationBars.firstMatch.buttons["Select a ScanbotSDK Demo"].tap()

        sleep(60)
        tablesQuery.cells.staticTexts["Document Scanner Demo"].tap()
        XCTAssert(app.alerts["Error"].waitForExistence(timeout: 1))
        app.alerts["Error"].buttons["OK"].tap()
    }
}
