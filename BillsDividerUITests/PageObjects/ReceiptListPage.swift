import XCTest

class ReceiptListPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    private var plusButton: XCUIElement {
        app.navigationBars.buttons["plus"]
    }

    private var ellipsisButton: XCUIElement {
        app.navigationBars.buttons["ellipsis"]
    }

    private var table: XCUIElement {
        app.tables.element
    }

    var isVisible: Bool {
        plusButton.exists && ellipsisButton.exists
    }

    @discardableResult func plusButtonTap() -> AddOverlayPage {
        plusButton.tap()
        return AddOverlayPage(app)
    }

    @discardableResult func ellipsisButtonTap() -> ReceiptListPage {
        ellipsisButton.tap()
        return self
    }
}
