import XCTest

class ReceiptListPage: Page {
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

    @discardableResult func tapEllipsisButton() -> ReceiptListPage {
        ellipsisButton.tap()
        return self
    }

    @discardableResult func tapDeleteAllButton() -> ReceiptListPage {
        deleteAllButton.tap()
        return self
    }

    @discardableResult func swipeLeftCell(atIndex index: Int) -> ReceiptListPage {
        table.cells.element(boundBy: index).swipeLeft()
        return self
    }

    @discardableResult func tapCellsDeleteButton(atIndex index: Int) -> ReceiptListPage {
        table.cells.element(boundBy: index).buttons["Delete"].tap()
        return self
    }

    @discardableResult func longPressCell(atIndex index: Int) -> ReceiptListPage {
        table.cells.element(boundBy: index).press(forDuration: 1)
        return self
    }

    @discardableResult func tapEditPositionButton() -> EditOverlayPage {
        editPositionButton.tap()
        return EditOverlayPage(app)
    }

    @discardableResult func tapRemovePositionButton() -> ReceiptListPage {
        deletePositionButton.tap()
        return self
    }

    func getAmountFromCell(atIndex index: Int) -> String {
        table.cells.element(boundBy: index).staticTexts.firstMatch.label
    }
}
