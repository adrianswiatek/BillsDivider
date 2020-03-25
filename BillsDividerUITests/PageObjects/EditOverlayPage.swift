import XCTest

class EditOverlayPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    private var navigationBar: XCUIElement {
        let addPositionNavigationBar = app.navigationBars["Add position"]
        return addPositionNavigationBar.exists ? addPositionNavigationBar : app.navigationBars["Edit position"]
    }

    private var confirmButton: XCUIElement {
        app.buttons["EditOverlayView.confirmButton"]
    }

    private var closeButton: XCUIElement {
        navigationBar.buttons["xmark"]
    }

    private var priceTextField: XCUIElement {
        app.textFields["EditOverlayView.priceTextField"]
    }

    private var addDiscountButton: XCUIElement {
        app.buttons["EditOverlayView.addDiscountButton"]
    }

    private var removeDiscountButton: XCUIElement {
        app.buttons["EditOverlayView.removeDiscountButton"]
    }

    private var discountStaticText: XCUIElement {
        app.staticTexts["EditOverlayView.discountStaticText"]
    }

    private var buyerSegmentedControl: XCUIElement {
        app.segmentedControls["BuyerSectionView.segmentedControl"]
    }

    private var ownerSegmentedControl: XCUIElement {
        app.segmentedControls["OwnerSectionView.segmentedControl"]
    }

    var isVisible: Bool {
        navigationBar.exists
    }

    var selectedIndexOfBuyerSegmentedControl: Int? {
        buyerSegmentedControl.buttons.allElementsBoundByIndex.enumerated().reduce(0) {
            $1.element.isSelected ? $1.offset : $0
        }
    }

    var selectedIndexOfOwnerSegmentedControl: Int? {
        ownerSegmentedControl.buttons.allElementsBoundByIndex.enumerated().reduce(0) {
            $1.element.isSelected ? $1.offset : $0
        }
    }

    var discountText: String {
        discountStaticText.label
    }

    @discardableResult func tapConfirmButton() -> EditOverlayPage {
        confirmButton.tap()
        return self
    }

    @discardableResult func tapCloseButton() -> ReceiptPage {
        closeButton.tap()
        return ReceiptPage(app)
    }

    @discardableResult func tapPriceTextField() -> EditOverlayPage {
        priceTextField.tap()
        return self
    }

    @discardableResult func typeIntoPriceTextField(_ text: String) -> EditOverlayPage {
        priceTextField.typeText(text)
        return self
    }

    @discardableResult func deletePriceTextFieldCharacter(count: Int = 1) -> EditOverlayPage {
        priceTextField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: count))
        return self
    }

    @discardableResult func tapAddDiscountButton() -> DiscountPopoverPage {
        addDiscountButton.tap()
        return DiscountPopoverPage(app)
    }

    @discardableResult func tapRemoveDiscountButton() -> EditOverlayPage {
        removeDiscountButton.tap()
        return self
    }

    @discardableResult func tapBuyerSegmentedControl(atIndex index: Int) -> EditOverlayPage {
        buyerSegmentedControl.buttons.element(boundBy: index).tap()
        return self
    }

    @discardableResult func tapOwnerSegmentedControl(atIndex index: Int) -> EditOverlayPage {
        ownerSegmentedControl.buttons.element(boundBy: index).tap()
        return self
    }

    func labelForBuyerSegmentedControl(atIndex index: Int) -> String {
        buyerSegmentedControl.buttons.element(boundBy: index).label
    }

    func labelForOwnerSegmentedControl(atIndex index: Int) -> String? {
        ownerSegmentedControl.buttons.element(boundBy: index).label
    }
}
