import XCTest

class SummaryPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    private var firstPersonStaticText: XCUIElement {
        app.staticTexts["SummaryView.firstPersonText"]
    }

    private var secondPersonStaticText: XCUIElement {
        app.staticTexts["SummaryView.secondPersonText"]
    }

    var isVisible: Bool {
        app.staticTexts["Summary"].exists
    }

    var firstPersonLabel: String {
        firstPersonStaticText.label
    }

    var secondPersonLabel: String {
        secondPersonStaticText.label
    }
}
