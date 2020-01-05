import XCTest

class SettingsPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    private var firstPersonTextField: XCUIElement {
        app.textFields.element(boundBy: 0)
    }

    private var secondPersonTextField: XCUIElement {
        app.textFields.element(boundBy: 1)
    }

    private var returnKey: XCUIElement {
        app.buttons["Return"]
    }

    var isVisible: Bool {
        app.staticTexts["Settings"].exists
    }

    @discardableResult func tapFirstPersonTextField() -> SettingsPage {
        firstPersonTextField.tap()
        return self
    }

    @discardableResult func tapSecondPersonTextField() -> SettingsPage {
        secondPersonTextField.tap()
        return self
    }

    @discardableResult func typeIntoFirstPersonTextField(_ text: String) -> SettingsPage {
        firstPersonTextField.typeText(text)
        return self
    }

    @discardableResult func typeIntoSecondPersonTextField(_ text: String) -> SettingsPage {
        secondPersonTextField.typeText(text)
        return self
    }

    @discardableResult func tapReturnKey() -> SettingsPage {
        returnKey.tap()
        return self
    }
}
