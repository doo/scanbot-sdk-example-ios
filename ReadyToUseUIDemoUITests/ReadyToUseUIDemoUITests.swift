//
//  ReadyToUseUIDemoUITests.swift
//  ReadyToUseUIDemoUITests
//
//  Created by Yevgeniy Knizhnik on 23.11.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import XCTest

class ReadyToUseUIDemoUITests: XCTestCase {

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
        
        tablesQuery.cells.staticTexts["Import Image"].tap()
        XCTAssert(app.buttons["Cancel"].waitForExistence(timeout: 4))
        app.buttons["Cancel"].tap()
        app.buttons["Done"].tap()
        
        tablesQuery.cells.staticTexts["View Images"].tap()
        XCTAssert(app.buttons["Back"].waitForExistence(timeout: 1))
        app.buttons["Back"].tap()
        
        tablesQuery.cells.staticTexts["Workflow"].tap()
        let elementsQuery = app.sheets["Select a Workflow"].scrollViews.otherElements
        elementsQuery.buttons["ID Card - Front + Back Image + MRZ"].tap()
        app.buttons["Cancel"].tap()
        
        tablesQuery.cells.staticTexts["Workflow"].tap()
        elementsQuery.buttons["SEPA Payform"].tap()
        app.buttons["Cancel"].tap()
        
        tablesQuery.cells.staticTexts["Scan QR-Code"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()
        
        tablesQuery.cells.staticTexts["Scan Machine Readable Zone"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()
        
        tablesQuery.cells.staticTexts["Scan ID card"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()
        
        tablesQuery.cells.staticTexts["Scan Barcodes in batch"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()
        
        tablesQuery.cells.staticTexts["Scan Bar Code"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()
        
        tablesQuery.cells.staticTexts["Extract text data"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()
        
        tablesQuery.cells.staticTexts["Scan Health Insurance Card"].tap()
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 1))
        app.buttons["Done"].tap()
        
    }
}
