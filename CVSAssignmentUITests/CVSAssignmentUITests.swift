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
        // Simulate tapping on the first image in the search results
        let firstImage = app.images.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == true")
            expectation(for: exists, evaluatedWith: firstImage, handler: nil)
            waitForExpectations(timeout: 5, handler: nil)

            XCTAssertTrue(firstImage.exists, "The first image card should exist.")
            
            // Attempt to scroll if the element is not hittable
            while !firstImage.isHittable {
                app.swipeUp()
                XCTAssertTrue(firstImage.isHittable, "The first image card should be visible and tappable.")
                
                firstImage.tap()
                XCTAssertTrue(app.navigationBars["Image Detail"].exists, "Navigating to detail view should display the correct title.")
            }
            
            XCTAssertTrue(firstImage.isHittable, "The first image card should be visible and tappable.")
            
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
