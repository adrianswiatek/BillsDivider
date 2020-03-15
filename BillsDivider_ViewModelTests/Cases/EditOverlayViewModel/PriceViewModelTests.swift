@testable import BillsDivider_ViewModel
import BillsDivider_Model
import Combine
import XCTest

class PriceViewModelTests: XCTestCase {
    private var sut: PriceViewModel!
    private var numberFormatter: NumberFormatter!
    private var decimalParser: DecimalParser!
    private var subscriptions: [AnyCancellable]!

    override func setUp() {
        super.setUp()
        subscriptions = []
        decimalParser = DecimalParser()
        numberFormatter = .twoFractionDigitsNumberFormatter
        sut = PriceViewModel(decimalParser: decimalParser, numberFormatter: numberFormatter)
    }

    override func tearDown() {
        sut = nil
        numberFormatter = nil
        decimalParser = nil
        subscriptions = nil
        super.tearDown()
    }

    func testPlaceholder_returnsFormattedZero() {
        XCTAssertEqual(sut.placeholder, numberFormatter.format(value: 0))
    }

    func testIsValid_whenInit_returnsFalse() {
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

    func testValidationMessage_whenInit_returnsEmptyString() {
        XCTAssertEqual(sut.validationMessage, "")
    }

    func testValidationMessage_whenTextIsSetToEmptyString_returnsEmptyString() {
        sut.text = ""
        XCTAssertEqual(sut.validationMessage, "")
    }

    func testValidationMessage_whenTextIsSetToOne_returnsEmptyString() {
        sut.text = "1"
        XCTAssertEqual(sut.validationMessage, "")
    }

    func testValidationMessage_whenTextIsSetToLetter_returnsInvalidValueMessage() {
        sut.text = "a"
        XCTAssertEqual(sut.validationMessage, "Invalid value")
    }

    func testText_whenInit_returnsEmptyString() {
        XCTAssertEqual(sut.text, "")
    }

    func testValuePublisher_whenTextIsSetToEmptyString_sendsNil() {
        let expectation = self.expectation(description: "Value has been sent")
        var result: Decimal? = nil

        sut.valuePublisher
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        sut.text = ""

        waitForExpectations(timeout: 0.3)
        XCTAssertNil(result)
    }

    func testValuePublisher_whenTextIsSetToOne_sendsOne() {
        let expectation = self.expectation(description: "Value has been sent")
        var result: Decimal? = nil

        sut.valuePublisher
            .dropFirst()
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        sut.text = "1"

        waitForExpectations(timeout: 0.3)
        XCTAssertEqual(result, 1)
    }

    func testValuePublisher_wjenTextIsSetToLetter_sendsNil() {
        let expectation = self.expectation(description: "Value has been sent")
        var result: Decimal? = nil

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
}
