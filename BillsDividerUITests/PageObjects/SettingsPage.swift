import XCTest

class SettingsPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    var isVisible: Bool {
        app.staticTexts["Settings"].exists
    }
}
