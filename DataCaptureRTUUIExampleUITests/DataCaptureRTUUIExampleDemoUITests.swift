//
//  DataCaptureRTUUIExampleUITests.swift
//  DataCaptureRTUUIExampleUITests
//
//  Created by Yevgeniy Knizhnik on 23.11.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import XCTest

class DataCaptureRTUUIExampleUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        
        addUIInterruptionMonitor(withDescription: "Camera allowance") { (alert) -> Bool in
            alert.buttons["OK"].tap()
            return true
        }

        tablesQuery.cells.staticTexts["Scan Document"].tap()
        XCTAssert(app.buttons["Cancel"].waitForExistence(timeout: 1))
        app.buttons["Cancel"].tap()
        
        tablesQuery.cells.staticTexts["Multiple objects scanner"].tap()
        XCTAssert(app.buttons["Cancel"].waitForExistence(timeout: 1))
        app.buttons["Cancel"].tap()
                
        tablesQuery.cells.staticTexts["View Images"].tap()
        XCTAssert(app.buttons["Scanbot SDK Demo"].waitForExistence(timeout: 1))
        app.buttons["Scanbot SDK Demo"].tap()
        
        tablesQuery.cells.staticTexts["Scan 2D Barcodes"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()

        tablesQuery.cells.staticTexts["Scan 1D Barcodes"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()

        tablesQuery.cells.staticTexts["Scan Barcodes in batch"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()

        tablesQuery.cells.staticTexts["Scan Machine Readable Zone"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()
        
        tablesQuery.cells.staticTexts["Scan German ID card"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()

        tablesQuery.cells.staticTexts["Scan German driver's license"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()

        tablesQuery.cells.staticTexts["Extract text data"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()
        
        tablesQuery.cells.staticTexts["Scan Check"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()
        
        tablesQuery.cells.staticTexts["Scan Health Insurance Card"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()
        
        tablesQuery.cells.staticTexts["Scan EU License Plate"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()
        
        // Test the license failure alert appears after 60 seconds.
        sleep(60)
        tablesQuery.cells.staticTexts["Scan Document"].tap()
        XCTAssert(app.alerts["Demo expired"].waitForExistence(timeout: 1))
        app.alerts["Demo expired"].buttons["Close App"].tap()
    }
}
