@testable import BillsDivider_ViewModel
import BillsDivider_Model
import Combine
import XCTest

class DiscountViewModelTests: XCTestCase {
    private var sut: DiscountViewModel!
    private var discountPopoverViewModel: DiscountPopoverViewModel!
    private var decimalParser: DecimalParser!

    private var subscriptions: [AnyCancellable]!

    override func setUp() {
        super.setUp()

        decimalParser = DecimalParser()
        discountPopoverViewModel = DiscountPopoverViewModel(
            decimalParser: decimalParser,
            numberFormatter: .twoFractionDigitsNumberFormatter
        )
        sut = DiscountViewModel(
            discountPopoverViewModel: discountPopoverViewModel,
            decimalParser: decimalParser
        )
        subscriptions = []
    }

    override func tearDown() {
        subscriptions = nil
        sut = nil
        discountPopoverViewModel = nil
        decimalParser = nil

        super.tearDown()
    }

    func testHasDiscount_whenTextIsSetToEmptyString_returnsFalse() {
        sut.text = ""
        XCTAssertFalse(sut.hasDiscount)
    }

    func testHasDiscount_whenTextIsSetToAnyValue_returnsTrue() {
        sut.text = "1"
        XCTAssertTrue(sut.hasDiscount)
    }

    func testShowDiscountPopover_whenCalled_setsPresentingPopoverToTrue() {
        sut.showDiscountPopover()
        XCTAssertTrue(sut.presentingPopover)
    }

    func testRemoveDiscount_whenCalled_setsTextToEmptyString() {
        sut.removeDiscount()
        XCTAssertEqual(sut.text, "")
    }

    func testValuePublisher_whenTextIsSetToEmptyString_sendsNil() {
        let expectation = self.expectation(description: "Value has been sent")
        var result: Decimal?

        sut.valuePublisher
            .dropFirst()
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        sut.text = ""

        waitForExpectations(timeout: 0.3)
        XCTAssertNil(result)
    }

    func testValuePublisher_whenTextIsSetToInvalidValue_sendsNil() {
        let expectation = self.expectation(description: "Value has been sent")
        var result: Decimal?

        sut.valuePublisher
            .dropFirst()
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        sut.text = "a"

        waitForExpectations(timeout: 0.3)
        XCTAssertNil(result)
    }

    func testValuePublisher_whenTextIsSetToCorrectValue_sendsDecimalValue() {
        let expectation = self.expectation(description: "Value has been sent")
        var result: Decimal?

        sut.valuePublisher
            .dropFirst()
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        sut.text = "1"

        waitForExpectations(timeout: 0.3)
        XCTAssertEqual(result, Decimal(integerLiteral: 1))
    }
}
