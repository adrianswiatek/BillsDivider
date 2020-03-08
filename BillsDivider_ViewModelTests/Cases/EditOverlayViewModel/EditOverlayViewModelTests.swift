@testable import BillsDivider_Model
@testable import BillsDivider_ViewModel
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
            decimalParser: DecimalParser(),
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
        XCTAssertEqual(sut.price.placeholder, numberFormatter.format(value: 0))
    }

    func testDismiss_setsPresentingToFalse() {
        var presenting: Bool = true
        sut = EditOverlayViewModel(
            presenting: Binding<Bool>(get: { presenting }, set: { presenting = $0 }),
            editOverlayStrategy: EditOverlayStrategyDummy(),
            peopleService: peopleService,
            decimalParser: DecimalParser(),
            numberFormatter: numberFormatter
        )
        sut.dismiss()
        XCTAssertFalse(presenting)
    }

    func testConfirmDidTap_whenAddAnotherIsEnabled_clearPriceText() {
        sut.price.text = "123"
        sut.addAnother = true

        sut.confirmDidTap()

        XCTAssertEqual(sut.price.text, "")
    }

    func testConfirmDidTap_whenAddAnotherIsDisabled_setsPresentingToFalse() {
        var presenting: Bool = true
        sut = EditOverlayViewModel(
            presenting: Binding<Bool>(get: { presenting }, set: { presenting = $0 }),
            editOverlayStrategy: EditOverlayStrategyDummy(),
            peopleService: peopleService,
            decimalParser: DecimalParser(),
            numberFormatter: numberFormatter
        )
        sut.price.text = "123"
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
            decimalParser: DecimalParser(),
            numberFormatter: numberFormatter
        )
        sut.positionAdded.sink { actualPosition = $0 }.store(in: &subscriptions)
        sut.price.text = "123.00"
        sut.buyer = .person(firstPerson)
        sut.owner = .person(secondPerson)

        sut.confirmDidTap()

        let expectedPosition = ReceiptPosition(amount: 123, buyer: .person(firstPerson), owner: .person(secondPerson))
        XCTAssertEqual(actualPosition, expectedPosition)
    }

    func testPriceText_withEmptyString_setsIsPriceCorrectToTrue() {
        sut.price.text = ""
        XCTAssertTrue(sut.price.isCorrect)
    }

    func testPriceText_withZero_setsIsPriceCorrectToTrue() {
        sut.price.text = "0"
        XCTAssertTrue(sut.price.isCorrect)
    }

    func testPriceText_withEmptyString_setsCanConfirmToFalse() {
        sut.price.text = ""
        XCTAssertFalse(sut.canConfirm)
    }

    func testPriceText_withZero_setsCanConfirmToFalse() {
        sut.price.text = "0"
        XCTAssertFalse(sut.canConfirm)
    }

    func testPriceText_withInvalidString_setsIsPriceCorrectToFalse() {
        sut.price.text = "invalid string"
        XCTAssertFalse(sut.price.isCorrect)
    }

    func testPriceText_withoutFractionDigits_setsIsPriceCorrectToTrue() {
        sut.price.text = "1"
        XCTAssertTrue(sut.price.isCorrect)

        sut.price.text = "1."
        XCTAssertTrue(sut.price.isCorrect)
    }

    func testPriceText_withTwoFractionDigits_setsIsPriceCorrectToTrue() {
        sut.price.text = ".99"
        XCTAssertTrue(sut.price.isCorrect)
    }

    func testPriceText_withThreeFractionDigits_setsIsPriceCorrectToFalse() {
        sut.price.text = ".999"
        XCTAssertFalse(sut.price.isCorrect)
    }

    func testPriceText_withFiveIntegerDigits_setsIsPriceCorrectToTrue() {
        sut.price.text = "12345"
        XCTAssertTrue(sut.price.isCorrect)

        sut.price.text = "12345.67"
        XCTAssertTrue(sut.price.isCorrect)
    }

    func testPriceText_withSixIntegerDigits_setsIsPriceCorrectToFalse() {
        sut.price.text = "123456"
        XCTAssertFalse(sut.price.isCorrect)

        sut.price.text = "123456.78"
        XCTAssertFalse(sut.price.isCorrect)
    }
}
