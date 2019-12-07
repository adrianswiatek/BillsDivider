import XCTest

class ReceiptListPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    // MARK: - Elements
    private var plusButton: XCUIElement {
        app.navigationBars.buttons["plus"]
    }

    private var ellipsisButton: XCUIElement {
        app.navigationBars.buttons["ellipsis"]
    }

    private var summaryButton: XCUIElement {
        app.tabBars.buttons["Summary"]
    }

    private var receiptButton: XCUIElement {
        app.tabBars.buttons["Receipt"]
    }

    private var table: XCUIElement {
        app.tables.element
    }

    // MARK: - Behaviors
    @discardableResult func plusButtonTap() -> AddOverlayPage {
        plusButton.tap()
        return AddOverlayPage(app)
    }

    @discardableResult func summaryButtonTap() -> SummaryPage {
        summaryButton.tap()
        return SummaryPage(app)
    }

    @discardableResult func ellipsisButtonTap() -> ReceiptListPage {
        ellipsisButton.tap()
        return self
    }
}
