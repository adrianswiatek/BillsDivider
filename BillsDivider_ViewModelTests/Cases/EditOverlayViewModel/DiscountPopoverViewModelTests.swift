@testable import BillsDivider_ViewModel
import BillsDivider_Model
import Combine
import XCTest

class DiscountPopoverViewModelTests: XCTestCase {
    private var sut: DiscountPopoverViewModel!
    private var decimalParser: DecimalParser!
    private var numberFormatter: NumberFormatter!

    private var subscriptions: [AnyCancellable]!

    override func setUp() {
        super.setUp()
        decimalParser = DecimalParser()
        numberFormatter = .twoFractionDigitsNumberFormatter
        sut = DiscountPopoverViewModel(decimalParser: decimalParser, numberFormatter: numberFormatter)
        subscriptions = []
    }

    override func tearDown() {
        subscriptions = nil
        sut = nil
        numberFormatter = nil
        decimalParser = nil
        super.tearDown()
    }

    func testText_whenInit_isSetToEmptyString() {
        XCTAssertEqual(sut.text, "")
    }

    func testIsValid_whenInit_isSetToFalse() {
        XCTAssertFalse(sut.isValid)
    }

    func testIsValid_whenTextIsSetToEmptyString_returnsFalse() {
        sut.text = ""
        XCTAssertFalse(sut.isValid)
    }

    func testIsValid_whenTextIsSetToZero_returnsFalse() {
        sut.text = "0"
        XCTAssertFalse(sut.isValid)
    }

    func testIsValid_whenTextIsSetToOne_returnsTrue() {
        sut.text = "1"
        XCTAssertTrue(sut.isValid)
    }

    func testIsValid_whenTextIsSetToLetter_returnsFalse() {
        sut.text = "a"
        XCTAssertFalse(sut.isValid)
    }

    func testConfirm_whenCalled_setsTextToEmptyString() {
        sut.confirm()
        XCTAssertEqual(sut.text, "")
    }

    func testConfirm_whenCalled_sendsDidDismiss() {
        let expectation = self.expectation(description: "Value has been send")

        sut.didDismissPublisher
            .sink { _ in expectation.fulfill() }
            .store(in: &subscriptions)

        sut.confirm()

        waitForExpectations(timeout: 0.3)
    }

    func testClose_whenCalled_setsTextToEmptyString() {
        sut.dismiss()
        XCTAssertEqual(sut.text, "")
    }

    func testClose_whenCalled_sendsDidDismiss() {
        let expectation = self.expectation(description: "Value has been send")

        sut.didDismissPublisher
            .sink { _ in expectation.fulfill() }
            .store(in: &subscriptions)

        sut.dismiss()

        waitForExpectations(timeout: 0.3)
    }
}
