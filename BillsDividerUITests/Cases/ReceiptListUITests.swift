import XCTest

class ReceiptListUITests: XCTestCase {
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
        let receiptListPage = ReceiptListPage(app)

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
            .tapEllipsisButton()
            .tapRemoveAllButton()

        XCTAssertEqual(receiptListPage.numberOfCells, 0)
    }

    func testCanRemoveSingleItem() {
        let receiptListPage = ReceiptListPage(app)

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
    }
}
