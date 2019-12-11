@testable import BillsDivider
import XCTest

class EditingModeStrategyTests: XCTestCase {
    private var sut: EditOverlayStrategy!

    override func setUp() {
        super.setUp()
        sut = AddingModeStrategy(receiptPosition: .empty)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
