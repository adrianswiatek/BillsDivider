import XCTest

class AddOverlayPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    // MARK: - Predicates
    var isVisible: Bool {
        app.navigationBars["Add position"].exists
    }
}
