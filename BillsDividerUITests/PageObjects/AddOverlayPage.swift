import XCTest

class AddOverlayPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    private var navigationBar: XCUIElement {
        app.navigationBars["Add position"]
    }

    private var confirmButton: XCUIElement {
        navigationBar.buttons["checkmark.circle.fill"]
    }

    private var closeButton: XCUIElement {
        navigationBar.buttons["xmark"]
    }

    private var priceTextField: XCUIElement {
        app.textFields.element
    }

    var isVisible: Bool {
        navigationBar.exists
    }

    @discardableResult func tapConfirmButton() -> AddOverlayPage {
        confirmButton.tap()
        return self
    }

    @discardableResult func tapCloseButton() -> ReceiptListPage {
        closeButton.tap()
        return ReceiptListPage(app)
    }

    @discardableResult func tapPriceTextField() -> AddOverlayPage {
        priceTextField.tap()
        return self
    }

    @discardableResult func typeIntoPriceTextField(_ text: String) -> AddOverlayPage {
        priceTextField.typeText(text)
        return self
    }
}
