import XCTest

class SummaryPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    // MARK: - Elements
    private var summaryStaticText: XCUIElement {
        app.staticTexts["Summary"]
    }

    // MARK: - Predicates
    var isVisible: Bool {
        summaryStaticText.exists
    }
}
