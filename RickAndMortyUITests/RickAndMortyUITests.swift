//
//  RickAndMortyUITests.swift
//  RickAndMortyUITests
//
//  Created by Henry Bautista on 2/01/26.
//

import XCTest

final class RickAndMortyUITests: XCTestCase {
    func test_appLaunchesAndShowsCharacterList() {
        let app = XCUIApplication()
        app.launch()
        let title = app.staticTexts["Characters"]
        XCTAssertTrue(title.waitForExistence(timeout: 5))
        let firstRow = app.cells.firstMatch
        XCTAssertTrue(firstRow.waitForExistence(timeout: 5))
    }

    func test_searchFilteringWorks() {
        let app = XCUIApplication()
        app.launch()
        let search = app.textFields["searchField"]
        XCTAssertTrue(search.waitForExistence(timeout: 5))

        search.tap()
        search.typeText("Rick")

        let cell = app.cells.firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

    func test_statusFilterSegmentedControl() {
        let app = XCUIApplication()
        app.launch()
        let aliveButton = app.buttons["status_alive"]
        XCTAssertTrue(aliveButton.waitForExistence(timeout: 5))

        aliveButton.tap()

        let cell = app.cells.firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }


    func test_navigationToDetailScreen() {
        let app = XCUIApplication()
        app.launch()
        let firstRow = app.cells.firstMatch
        XCTAssertTrue(firstRow.waitForExistence(timeout: 5))

        firstRow.tap()

        XCTAssertTrue(app.staticTexts["detailTitle"].waitForExistence(timeout: 5))
    }
}
