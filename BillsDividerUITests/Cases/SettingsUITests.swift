import XCTest

class SettingsUITests: XCTestCase {
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

    func testCanUpdatePepoleNames() {
        let firstPersonName = "Geralt"
        let secondPersonName = "Yennefer"

        ReceiptPage(app)
            .tapPlusButton()
            .tapPriceTextField()
            .typeIntoPriceTextField("1")
            .tapBuyerSegmentedControl(atIndex: 0)
            .tapOwnerSegmentedControl(atIndex: 1)
            .tapConfirmButton()
            .tapCloseButton()

        let tabBarPage = TabBarPage(app)

        tabBarPage
            .tapSettingsButton()
            .tapFirstPersonTextField()
            .typeIntoFirstPersonTextField(firstPersonName)
            .tapSecondPersonTextField()
            .typeIntoSecondPersonTextField(secondPersonName)
            .tapReturnKey()

        let summaryPage = tabBarPage
            .tapSummaryButton()

        XCTAssertEqual(summaryPage.firstPersonLabel, firstPersonName)
        XCTAssertEqual(summaryPage.secondPersonLabel, secondPersonName)

        let receiptPage = tabBarPage
            .tapReceiptButton()

        XCTAssertEqual(receiptPage.buyerLabelFromCell(atIndex: 0), firstPersonName)
        XCTAssertEqual(receiptPage.ownerLabelFromCell(atIndex: 0), secondPersonName)

        let editOverlayPage = receiptPage
            .tapPlusButton()

        XCTAssertEqual(editOverlayPage.labelForBuyerSegmentedControl(atIndex: 0), firstPersonName)
        XCTAssertEqual(editOverlayPage.labelForBuyerSegmentedControl(atIndex: 1), secondPersonName)
        XCTAssertEqual(editOverlayPage.labelForOwnerSegmentedControl(atIndex: 0), firstPersonName)
        XCTAssertEqual(editOverlayPage.labelForOwnerSegmentedControl(atIndex: 1), secondPersonName)
    }
}
