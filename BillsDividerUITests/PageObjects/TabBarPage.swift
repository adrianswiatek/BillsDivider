import XCTest

class TabBarPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    private var receiptButton: XCUIElement {
        app.tabBars.buttons["Receipt"]
    }

    private var settingsButton: XCUIElement {
        app.tabBars.buttons["Settings"]
    }

    private var summaryButton: XCUIElement {
        app.tabBars.buttons["Summary"]
    }

    var isVisible: Bool {
        summaryButton.exists && receiptButton.exists
    }

    var isReceiptButtonSelected: Bool {
        receiptButton.isSelected
    }

    var isSummaryButtonSelected: Bool {
        summaryButton.isSelected
    }

    var isSettingsButtonSelected: Bool {
        settingsButton.isSelected
    }

    @discardableResult func tapReceiptButton() -> ReceiptPage {
        receiptButton.tap()
        return ReceiptPage(app)
    }

    @discardableResult func tapSummaryButton() -> SummaryPage {
        summaryButton.tap()
        return SummaryPage(app)
    }

    @discardableResult func tapSettingsButton() -> SettingsPage {
        settingsButton.tap()
        return SettingsPage(app)
    }
}
