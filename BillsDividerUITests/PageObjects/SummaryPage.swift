import XCTest

class SummaryPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    private var summaryStaticText: XCUIElement {
        app.staticTexts["Summary"]
    }

    var isVisible: Bool {
        summaryStaticText.exists
    }
}
