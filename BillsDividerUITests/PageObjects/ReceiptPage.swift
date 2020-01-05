import XCTest

class ReceiptPage: Page {
    private let app: XCUIApplication

    required init(_ app: XCUIApplication) {
        self.app = app
    }

    private var plusButton: XCUIElement {
        app.navigationBars.buttons["plus"]
    }

    private var ellipsisButton: XCUIElement {
        app.navigationBars.buttons["ellipsis"]
    }

    private var table: XCUIElement {
        app.tables.element
    }

    private var sheet: XCUIElement {
        app.sheets.element
    }

    private var deleteAllButton: XCUIElement {
        sheet.buttons["Delete all"]
    }

    private var editPositionButton: XCUIElement {
        app.buttons["Edit position"]
    }

    private var deletePositionButton: XCUIElement {
        app.buttons["Delete position"]
    }

    var isVisible: Bool {
        plusButton.exists && ellipsisButton.exists
    }

    var numberOfCells: Int {
        table.cells.count
    }

    @discardableResult func tapPlusButton() -> EditOverlayPage {
        plusButton.tap()
        return EditOverlayPage(app)
    }

    @discardableResult func tapEllipsisButton() -> ReceiptPage {
        ellipsisButton.tap()
        return self
    }

    @discardableResult func tapDeleteAllButton() -> ReceiptPage {
        deleteAllButton.tap()
        return self
    }

    @discardableResult func swipeLeftCell(atIndex index: Int) -> ReceiptPage {
        table.cells.element(boundBy: index).swipeLeft()
        return self
    }

    @discardableResult func tapCellsDeleteButton(atIndex index: Int) -> ReceiptPage {
        table.cells.element(boundBy: index).buttons["Delete"].tap()
        return self
    }

    @discardableResult func longPressCell(atIndex index: Int) -> ReceiptPage {
        table.cells.element(boundBy: index).press(forDuration: 1)
        return self
    }

    @discardableResult func tapEditPositionButton() -> EditOverlayPage {
        editPositionButton.tap()
        return EditOverlayPage(app)
    }

    @discardableResult func tapRemovePositionButton() -> ReceiptPage {
        deletePositionButton.tap()
        return self
    }

    func amountFromCell(atIndex index: Int) -> String {
        table.cells.element(boundBy: index).staticTexts.element(boundBy: 0).label
    }

    func buyerLabelFromCell(atIndex index: Int) -> String {
        table.cells.element(boundBy: index).staticTexts.element(boundBy: 1).label
    }

    func ownerLabelFromCell(atIndex index: Int) -> String {
        table.cells.element(boundBy: index).staticTexts.element(boundBy: 2).label
    }
}
