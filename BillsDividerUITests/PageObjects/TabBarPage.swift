import XCTest

class TabBarPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    private var summaryButton: XCUIElement {
        app.tabBars.buttons["Summary"]
    }

    private var receiptButton: XCUIElement {
        app.tabBars.buttons["Receipt"]
    }

    var isSummaryButtonSelected: Bool {
        summaryButton.isSelected
    }

    var isReceiptButtonSelected: Bool {
        receiptButton.isSelected
    }

    func tapSummaryButton() -> SummaryPage {
        summaryButton.tap()
        return SummaryPage(app)
    }

    func tapReceiptButton() -> ReceiptListPage {
        receiptButton.tap()
        return ReceiptListPage(app)
    }
}
