import XCTest

class TabsUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testTabBar_canNavigateBetweenTabs() {
        let tabBarPage = TabBarPage(app)
        XCTAssertTrue(tabBarPage.isVisible)
        XCTAssertTrue(tabBarPage.isReceiptButtonSelected)
        XCTAssertTrue(ReceiptListPage(app).isVisible)

        let summaryPage = tabBarPage.tapSummaryButton()
        XCTAssertTrue(tabBarPage.isSummaryButtonSelected)
        XCTAssertTrue(summaryPage.isVisible)

        let receiptPage = tabBarPage.tapReceiptButton()
        XCTAssertTrue(tabBarPage.isReceiptButtonSelected)
        XCTAssertTrue(receiptPage.isVisible)
    }
}
