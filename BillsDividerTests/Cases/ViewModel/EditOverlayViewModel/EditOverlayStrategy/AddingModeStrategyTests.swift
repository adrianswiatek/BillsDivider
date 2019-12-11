@testable import BillsDivider
import XCTest

class AddingModeStrategyTests: XCTestCase {
    private var sut: EditingModeStrategy!

    override func setUp() {
        super.setUp()
        sut = EditingModeStrategy(receiptPosition: .empty, numberFormatter: .twoFractionDigitsNumberFormatter)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
