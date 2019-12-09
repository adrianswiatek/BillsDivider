@testable import BillsDivider
import Combine
import SwiftUI
import XCTest

class AddOverlayViewModelTests: XCTestCase {
    private var sut: AddOverlayViewModel!
    private var subscriptions: [AnyCancellable]!

    private var numberFormatter: NumberFormatter {
        .twoFractionDigitsNumberFormatter
    }

    override func setUp() {
        super.setUp()
        sut = AddOverlayViewModel(
            presenting: .constant(true),
            buyer: .me,
            owner: .all,
            numberFormatter: numberFormatter
        )
        subscriptions = []
    }

    override func tearDown() {
        subscriptions = nil
        sut = nil
        super.tearDown()
    }

    func testInit_pricePlaceHolderText_returnsFormattedZero() {
        XCTAssertEqual(sut.pricePlaceHolderText, numberFormatter.format(value: 0))
    }

    func testDismiss_setsPresentingToFalse() {
        var presenting: Bool = true
        sut = AddOverlayViewModel(
            presenting: Binding<Bool>(get: { presenting }, set: { presenting = $0 }),
            buyer: .me,
            owner: .all,
            numberFormatter: numberFormatter
        )
        sut.dismiss()
        XCTAssertFalse(presenting)
    }

    func testConfirmDidTap_whenAddAnotherIsEnabled_clearPriceText() {
        sut.priceText = "123"
        sut.addAnother = true

        sut.confirmDidTap()

        XCTAssertEqual(sut.priceText, "")
    }

    func testConfirmDidTap_whenAddAnotherIsDisabled_setsPresentingToFalse() {
        var presenting: Bool = true
        sut = AddOverlayViewModel(
            presenting: Binding<Bool>(get: { presenting }, set: { presenting = $0 }),
            buyer: .me,
            owner: .all,
            numberFormatter: numberFormatter
        )
        sut.priceText = "123"
        sut.addAnother = false

        sut.confirmDidTap()

        XCTAssertFalse(presenting)
    }

    func testConfirmDidTap_withProperAmount_respectivePositionAddedIsSent() {
        var receiptPosition: ReceiptPosition?
        sut.positionAdded.sink { receiptPosition = $0 }.store(in: &subscriptions)
        sut.priceText = "123.00"
        sut.buyer = .notMe
        sut.owner = .me

        sut.confirmDidTap()

        XCTAssertEqual(receiptPosition, ReceiptPosition(amount: 123, buyer: .notMe, owner: .me))
    }

    func testPriceText_withEmptyString_setsIsPriceCorrectToTrue() {
        sut.priceText = ""
        XCTAssertTrue(sut.isPriceCorrect)
    }

    func testPriceText_withEmptyString_setsCanConfirmToFalse() {
        sut.priceText = ""
        XCTAssertFalse(sut.canConfirm)
    }

    func testPriceText_withInvalidString_setsIsPriceCorrectToFalse() {
        sut.priceText = "invalid string"
        XCTAssertFalse(sut.isPriceCorrect)
    }

    func testPriceText_withoutFractionDigits_setsIsPriceCorrectToTrue() {
        sut.priceText = "1"
        XCTAssertTrue(sut.isPriceCorrect)

        sut.priceText = "1."
        XCTAssertTrue(sut.isPriceCorrect)
    }

    func testPriceText_withTwoFractionDigits_setsIsPriceCorrectToTrue() {
        sut.priceText = ".99"
        XCTAssertTrue(sut.isPriceCorrect)
    }

    func testPriceText_withThreeFractionDigits_setsIsPriceCorrectToFalse() {
        sut.priceText = ".999"
        XCTAssertFalse(sut.isPriceCorrect)
    }

    func testPriceText_withFiveIntegerDigits_setsIsPriceCorrectToTrue() {
        sut.priceText = "12345"
        XCTAssertTrue(sut.isPriceCorrect)

        sut.priceText = "12345.67"
        XCTAssertTrue(sut.isPriceCorrect)
    }

    func testPriceText_withSixIntegerDigits_setsIsPriceCorrectToFalse() {
        sut.priceText = "123456"
        XCTAssertFalse(sut.isPriceCorrect)

        sut.priceText = "123456.78"
        XCTAssertFalse(sut.isPriceCorrect)
    }
}
