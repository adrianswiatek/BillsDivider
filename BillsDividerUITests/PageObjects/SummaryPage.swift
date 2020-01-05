import XCTest

class SummaryPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    private var titleStaticText: XCUIElement {
        app.staticTexts["SummaryView.title"]
    }

    private var firstPersonStaticText: XCUIElement {
        app.staticTexts["SummaryView.firstPerson"]
    }

    private var secondPersonStaticText: XCUIElement {
        app.staticTexts["SummaryView.secondPerson"]
    }

    var isVisible: Bool {
        titleStaticText.exists
    }

    var firstPersonLabel: String {
        firstPersonStaticText.label
    }

    var secondPersonLabel: String {
        secondPersonStaticText.label
    }
}
