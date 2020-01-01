@testable import BillsDivider
import Combine
import SwiftUI
import XCTest

class EditOverlayViewModelTests: XCTestCase {
    private var sut: EditOverlayViewModel!
    private var peopleService: PeopleService!
    private var subscriptions: [AnyCancellable]!

    private var numberFormatter: NumberFormatter {
        .twoFractionDigitsNumberFormatter
    }

    override func setUp() {
        super.setUp()
        peopleService = PeopleServiceFake()
        sut = EditOverlayViewModel(
            presenting: .constant(true),
            editOverlayStrategy: EditOverlayStrategyDummy(),
            peopleService: peopleService,
            numberFormatter: numberFormatter
        )
        subscriptions = []
    }

    override func tearDown() {
        subscriptions = nil
        sut = nil
        peopleService = nil
        super.tearDown()
    }

    func testInit_pricePlaceHolderText_returnsFormattedZero() {
        XCTAssertEqual(sut.pricePlaceHolderText, numberFormatter.format(value: 0))
    }

    func testDismiss_setsPresentingToFalse() {
        var presenting: Bool = true
        sut = EditOverlayViewModel(
            presenting: Binding<Bool>(get: { presenting }, set: { presenting = $0 }),
            editOverlayStrategy: EditOverlayStrategyDummy(),
            peopleService: peopleService,
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
        sut = EditOverlayViewModel(
            presenting: Binding<Bool>(get: { presenting }, set: { presenting = $0 }),
            editOverlayStrategy: EditOverlayStrategyDummy(),
            peopleService: peopleService,
            numberFormatter: numberFormatter
        )
        sut.priceText = "123"
        sut.addAnother = false

        sut.confirmDidTap()

        XCTAssertFalse(presenting)
    }

    func testConfirmDidTap_withProperAmount_respectivePositionAddedIsSent() {
        let firstPerson: Person = .withGeneratedName(forNumber: 1)
        let secondPerson: Person = .withGeneratedName(forNumber: 2)
        var actualPosition: ReceiptPosition?
        sut = EditOverlayViewModel(
            presenting: .constant(true),
            editOverlayStrategy: AddingModeStrategy(receiptPosition: .empty),
            peopleService: peopleService,
            numberFormatter: numberFormatter
        )
        sut.positionAdded.sink { actualPosition = $0 }.store(in: &subscriptions)
        sut.priceText = "123.00"
        sut.buyer = .person(firstPerson)
        sut.owner = .person(secondPerson)

        sut.confirmDidTap()

        let expectedPosition = ReceiptPosition(amount: 123, buyer: .person(firstPerson), owner: .person(secondPerson))
        XCTAssertEqual(actualPosition, expectedPosition)
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
