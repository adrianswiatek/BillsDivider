import XCTest

class BillsDividerUITests: XCTestCase {
    private var app: XCUIApplication!

    // MARK: - Lifecycle methods
    override func setUp() {
        continueAfterFailure = true

        app = XCUIApplication()
        app.launch()
    }

    // MARK: - Helpers
    private func tapNavigationBarPlusButton() {
        app.navigationBars.element.buttons["plus"].tap()
    }

    private func tapNavigationBarEllipsisButton() {
        app.navigationBars.element.buttons["ellipsis"].tap()
    }

    private func tapSheetRemoveAllButton() {
        app.sheets.element.buttons["Remove all"].tap()
    }

    private func tapSummaryTabBarButton() {
        app.tabBars.firstMatch.buttons["Summary"].tap()
    }

    private func tapNavigationBarConfirmButton() {
        app.navigationBars["Add position"].buttons["checkmark.circle.fill"].tap()
    }

    private func tapNavigationBarCloseButton() {
        app.navigationBars["Add position"].buttons["xmark"].tap()
    }

    // MARK: - Tests
    func testPlusButton_onTap_opensAddPositionView() {
        tapNavigationBarPlusButton()

        let addPositionNavigationBar = app.navigationBars["Add position"]
        XCTAssertTrue(addPositionNavigationBar.exists)
    }

    func testSummaryButton_onTap_opensSummaryView() {
        tapSummaryTabBarButton()

        let summaryStaticText = app.staticTexts["Summary"]
        XCTAssertTrue(summaryStaticText.exists)
    }

    func testCanRemoveAllItems() {
        tapNavigationBarPlusButton()

        let priceTextField = app.textFields.element
        priceTextField.tap()
        priceTextField.typeText("1")

        tapNavigationBarConfirmButton()

        priceTextField.tap()
        priceTextField.typeText("2")

        tapNavigationBarConfirmButton()

        priceTextField.tap()
        priceTextField.typeText("3")

        tapNavigationBarConfirmButton()
        tapNavigationBarCloseButton()

        expectation(for: NSPredicate(format: "count == 3"), evaluatedWith: app.tables.element.cells)
        waitForExpectations(timeout: 1)

        tapNavigationBarEllipsisButton()
        tapSheetRemoveAllButton()

        expectation(for: NSPredicate(format: "count == 0"), evaluatedWith: app.tables.element.cells)
        waitForExpectations(timeout: 1)
    }
}
