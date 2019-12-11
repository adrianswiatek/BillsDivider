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

    private var removeAllButton: XCUIElement {
        sheet.buttons["Remove all"]
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

    @discardableResult func tapRemoveAllButton() -> ReceiptListPage {
        removeAllButton.tap()
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
}
