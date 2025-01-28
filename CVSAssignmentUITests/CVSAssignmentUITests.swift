//
//  CVSAssignmentUITests.swift
//  CVSAssignmentUITests
//
//  Created by Rajesh Bandarupalli on 1/15/25.
//

import XCTest

final class CVSAssignmentUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        // Any initial setup required before each test
    }
    
    override func tearDownWithError() throws {
        // Teardown code after each test
    }
    
    func testSearchFieldExists() {
        let app = XCUIApplication()
        app.launch()
        
        let searchField = app.searchFields["Search by tags"]
        XCTAssertTrue(searchField.exists, "The search field should exist.")
    }
    
    func testSearchFunctionality() {
        let app = XCUIApplication()
        app.launch()
        
        // Ensure the search field is visible
        let searchField = app.searchFields["Search by tags"]
        XCTAssertTrue(searchField.exists, "The search field should be visible.")
        
        searchField.tap()
        searchField.typeText("Nature")
        
        if app.keyboards.buttons["Search"].exists {
            app.keyboards.buttons["Search"].tap()
        } else if app.keyboards.buttons["Return"].exists {
            app.keyboards.buttons["Return"].tap()
        } else {
            XCTFail("Neither 'Search' nor 'Return' button was found. Ensure the keyboard is active.")
        }
        
        // Verify search results are displayed
        let firstResult = app.images.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: firstResult, handler: nil)
        waitForExpectations(timeout: 5)
        XCTAssertTrue(firstResult.exists, "The first search result should be displayed.")
    }
    
    func testImageDetailNavigation() {
        let app = XCUIApplication()
        app.launch()
        
        let searchField = app.searchFields["Search by tags"]
        searchField.tap()
        searchField.typeText("Nature")
        
        if app.keyboards.buttons["Search"].exists {
            app.keyboards.buttons["Search"].tap()
        } else if app.keyboards.buttons["Return"].exists {
            app.keyboards.buttons["Return"].tap()
        } else {
            XCTFail("Neither 'Search' nor 'Return' button was found. Ensure the keyboard is active.")
        }
        
        // Simulate tapping on the first image in the search results
        let firstImage = app.images.element(boundBy: 0)
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: firstImage, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        // Scroll until the element is hittable
        let timeout = 5.0
        let startTime = Date()
        while !firstImage.isHittable && Date().timeIntervalSince(startTime) < timeout {
            app.swipeUp()
        }
        
        XCTAssertTrue(firstImage.isHittable, "The first image card should be visible and tappable within the timeout.")
        firstImage.tap()
        
        XCTAssertTrue(app.navigationBars["Image Detail"].exists, "Navigating to detail view should display the correct title.")
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
