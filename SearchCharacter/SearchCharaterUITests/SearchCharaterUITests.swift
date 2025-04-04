//
//  SearchCharaterUITests.swift
//  SearchCharaterUITests
//
//  Created by ranjith kumar reddy b perkampally on 4/1/25.
//

import XCTest

final class SearchCharacterUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testSearchAndNavigateToDetailView() throws {
        // 1. Find the search field and type "rick"
        let searchField = app.textFields["Search characters..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2), "Search field doesn't exist")
        searchField.tap()
        searchField.typeText("rick")

        // 2. Wait for the list to load
        let cell = app.cells.firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 5), "No cells loaded after search")

        // 3. Tap the first character cell
        cell.tap()

        // 4. Check that the detail screen appears with expected data
        let title = app.staticTexts["Rick Sanchez"]
        XCTAssertTrue(title.waitForExistence(timeout: 3), "Detail view did not appear")

        let species = app.staticTexts["Species: Human"]
        XCTAssertTrue(species.exists, "Species info missing")
    }
}
