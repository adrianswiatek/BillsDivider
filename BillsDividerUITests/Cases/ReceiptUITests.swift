import XCTest

class ReceiptUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["ui-testing"]
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testCanRemoveAllItems() {
        let receiptPage = ReceiptPage(app)

        XCTAssertEqual(receiptPage.numberOfCells, 0)

        receiptPage
            .tapPlusButton()
            .tapPriceTextField()
            .typeIntoPriceTextField("1")
            .tapConfirmButton()
            .typeIntoPriceTextField("2")
            .tapConfirmButton()
            .tapCloseButton()

        XCTAssertEqual(receiptPage.numberOfCells, 2)

        receiptPage
            .tapEllipsisButton()
            .tapDeleteAllButton()

        XCTAssertEqual(receiptPage.numberOfCells, 0)
    }

    func testCanRemoveSingleItemBySwipeGesture() {
        let receiptListPage = ReceiptPage(app)

        XCTAssertEqual(receiptListPage.numberOfCells, 0)

        receiptListPage
            .tapPlusButton()
            .tapPriceTextField()
            .typeIntoPriceTextField("1")
            .tapConfirmButton()
            .typeIntoPriceTextField("2")
            .tapConfirmButton()
            .tapCloseButton()

        XCTAssertEqual(receiptListPage.numberOfCells, 2)

        receiptListPage
            .swipeLeftCell(atIndex: 0)
            .tapCellsDeleteButton(atIndex: 0)

        XCTAssertEqual(receiptListPage.numberOfCells, 1)
        XCTAssertEqual(receiptListPage.amountFromCell(atIndex: 0), "1.00")
    }

    func testCanRemoveSingleItemFromContextMenu() {
        let receiptListPage = ReceiptPage(app)

        XCTAssertEqual(receiptListPage.numberOfCells, 0)

        receiptListPage
            .tapPlusButton()
            .tapPriceTextField()
            .typeIntoPriceTextField("1")
            .tapConfirmButton()
            .tapPriceTextField()
            .typeIntoPriceTextField("2")
            .tapConfirmButton()
            .tapCloseButton()

        XCTAssertEqual(receiptListPage.numberOfCells, 2)

        receiptListPage
            .longPressCell(atIndex: 0)
            .tapRemovePositionButton()

        XCTAssertEqual(receiptListPage.numberOfCells, 1)
        XCTAssertEqual(receiptListPage.amountFromCell(atIndex: 0), "1.00")
    }

    func testCanEditAmount() {
        let receiptPage = ReceiptPage(app)

        receiptPage
            .tapPlusButton()
            .tapPriceTextField()
            .typeIntoPriceTextField("1.00")
            .tapConfirmButton()
            .tapCloseButton()

        XCTAssertEqual(receiptPage.amountFromCell(atIndex: 0), "1.00")

        receiptPage
            .longPressCell(atIndex: 0)
            .tapEditPositionButton()
            .tapPriceTextField()
            .deletePriceTextFieldCharacter(count: 3)
            .typeIntoPriceTextField("0.00")
            .tapConfirmButton()

        XCTAssertEqual(receiptPage.amountFromCell(atIndex: 0), "10.00")
    }
}
