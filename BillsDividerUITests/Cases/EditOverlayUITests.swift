import XCTest

class EditOverlayUITests: XCTestCase {
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

    func testRememberBuyerAndOwnerPositionsWhileAddingItems() {
        let editOverlayPage = ReceiptListPage(app)
            .tapPlusButton()
            .tapPriceTextField()
            .typeIntoPriceTextField("1")
            .tapBuyerSegmentedControl(atIndex: 1)
            .tapOwnerSegmentedControl(atIndex: 0)
            .tapConfirmButton()

        XCTAssertEqual(editOverlayPage.selectedIndexOfBuyerSegmentedControl, 1)
        XCTAssertEqual(editOverlayPage.selectedIndexOfOwnerSegmentedControl, 0)
    }
}
