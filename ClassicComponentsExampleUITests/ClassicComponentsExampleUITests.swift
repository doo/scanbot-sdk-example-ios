//
//  ClassicComponentsExampleUITests.swift
//  ClassicComponentsExampleUITests
//
//  Created by Yevgeniy Knizhnik on 23.11.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import XCTest

class ClassicComponentsExampleUITests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }
    
    func testMainUI() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        
        if #available(iOS 13.0, *) {
            addUIInterruptionMonitor(withDescription: "Camera allowance") { (alert) -> Bool in
                alert.buttons["OK"].tap()
                return true
            }
            
            tablesQuery.cells.staticTexts["Document Scanner Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["Document Scanner Aspect Ratio Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["Multiple Objects Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["Payform Scanner Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["Check Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["Barcode Scanner Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["Barcode Scanner with Finder View Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["Text Pattern Scanner Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["Machine Readable Zones Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["Credit Card Scanner Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["European Health Insurance Card Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["Medical Certificate Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["NFC Passport Reader Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["Document Data Extractor Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["Quality Analyzer Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
            
            tablesQuery.cells.staticTexts["Adjustable Filters Demo"].tap()
            _ = app.navigationBars.firstMatch.buttons.firstMatch.waitForExistence(timeout: 3)
            app.navigationBars.firstMatch.buttons["Select a Classic Component Demo"].tap()
        }
        
        // Test the license failure alert appears after 60 seconds.
        sleep(60)
        tablesQuery.cells.staticTexts["Document Scanner Demo"].tap()
        XCTAssert(app.alerts["Error"].waitForExistence(timeout: 1))
        app.alerts["Error"].buttons["Ok"].tap()
    }
}
