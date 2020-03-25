import XCTest

class DiscountPopoverPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    private var discountTextField: XCUIElement {
        app.textFields["DiscountPopover.discountTextField"]
    }

    private var okButton: XCUIElement {
        app.buttons["DiscountPopover.okButton"]
    }

    private var discardButton: XCUIElement {
        app.buttons["DiscountPopover.discardButton"]
    }

    var isVisible: Bool {
        discountTextField.exists
    }

    @discardableResult func tapDiscountTextField() -> DiscountPopoverPage {
        discountTextField.tap()
        return self
    }

    @discardableResult func typeIntoDiscountTextField(_ text: String) -> DiscountPopoverPage {
        discountTextField.typeText(text)
        return self
    }

    @discardableResult func tapOkButton() -> EditOverlayPage {
        okButton.tap()
        return EditOverlayPage(app)
    }

    @discardableResult func tapDiscardButton() -> EditOverlayPage {
        discardButton.tap()
        return EditOverlayPage(app)
    }
}
