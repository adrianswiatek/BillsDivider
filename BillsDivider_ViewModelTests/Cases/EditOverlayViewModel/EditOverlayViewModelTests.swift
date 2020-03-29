@testable import BillsDivider_Model
@testable import BillsDivider_ViewModel
import Combine
import SwiftUI
import XCTest

class EditOverlayViewModelTests: XCTestCase {
    private var sut: EditOverlayViewModel!
    private var peopleService: PeopleService!
    private var viewModel: EditOverlayViewModel!
    private var priceViewModel: PriceViewModel!
    private var discountViewModel: DiscountViewModel!
    private var discountPopoverViewModel: DiscountPopoverViewModel!
    private var decimalParser: DecimalParser!

    private var subscriptions: [AnyCancellable]!

    private var numberFormatter: NumberFormatter {
        .twoFractionDigitsNumberFormatter
    }

    override func setUp() {
        super.setUp()

        decimalParser = DecimalParser()
        peopleService = PeopleServiceFake()
        discountPopoverViewModel = .init(decimalParser: decimalParser, numberFormatter: numberFormatter)
        discountViewModel = .init(discountPopoverViewModel: discountPopoverViewModel, decimalParser: decimalParser)
        priceViewModel = .init(decimalParser: decimalParser, numberFormatter: numberFormatter)
        sut = EditOverlayViewModel(
            presenting: .constant(true),
            priceViewModel: priceViewModel,
            discountViewModel: discountViewModel,
            discountPopoverViewModel: discountPopoverViewModel,
            editOverlayState: EditOverlayStateDummy(),
            buyerViewModel: BuyerViewModel(peopleService: peopleService),
            ownerViewModel: OwnerViewModel(peopleService: peopleService),
            decimalParser: decimalParser
        )
        subscriptions = []
    }

    override func tearDown() {
        subscriptions = nil
        sut = nil
        priceViewModel = nil
        discountViewModel = nil
        discountPopoverViewModel = nil
        peopleService = nil
        decimalParser = nil

        super.tearDown()
    }

    func testInit_pricePlaceHolderText_returnsFormattedZero() {
        XCTAssertEqual(sut.priceViewModel.placeholder, numberFormatter.format(value: 0))
    }

    func testDismiss_setsPresentingToFalse() {
        var presenting: Bool = true
        sut = EditOverlayViewModel(
            presenting: Binding<Bool>(get: { presenting }, set: { presenting = $0 }),
            priceViewModel: priceViewModel,
            discountViewModel: discountViewModel,
            discountPopoverViewModel: discountPopoverViewModel,
            editOverlayState: EditOverlayStateDummy(),
            buyerViewModel: BuyerViewModel(peopleService: peopleService),
            ownerViewModel: OwnerViewModel(peopleService: peopleService),
            decimalParser: decimalParser
        )
        sut.dismiss()
        XCTAssertFalse(presenting)
    }

    func testConfirmDidTap_whenAddAnotherIsDisabled_setsPresentingToFalse() {
        var presenting: Bool = true
        sut = EditOverlayViewModel(
            presenting: Binding<Bool>(get: { presenting }, set: { presenting = $0 }),
            priceViewModel: priceViewModel,
            discountViewModel: discountViewModel,
            discountPopoverViewModel: discountPopoverViewModel,
            editOverlayState: EditOverlayStateDummy(),
            buyerViewModel: BuyerViewModel(peopleService: peopleService),
            ownerViewModel: OwnerViewModel(peopleService: peopleService),
            decimalParser: decimalParser
        )
        sut.priceViewModel.text = "123"
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
            priceViewModel: priceViewModel,
            discountViewModel: discountViewModel,
            discountPopoverViewModel: discountPopoverViewModel,
            editOverlayState: AddingModeState(receiptPosition: .empty),
            buyerViewModel: BuyerViewModel(peopleService: peopleService),
            ownerViewModel: OwnerViewModel(peopleService: peopleService),
            decimalParser: decimalParser
        )
        sut.positionAdded.sink { actualPosition = $0 }.store(in: &subscriptions)
        sut.priceViewModel.text = "123.00"
        sut.buyerViewModel.buyer = .person(firstPerson)
        sut.ownerViewModel.owner = .person(secondPerson)

        sut.confirmDidTap()

        let expectedPosition = ReceiptPosition(amount: 123, buyer: .person(firstPerson), owner: .person(secondPerson))
        XCTAssertEqual(actualPosition, expectedPosition)
    }

    func testPriceText_withEmptyString_setsIsPriceCorrectToFalse() {
        sut.priceViewModel.text = ""
        XCTAssertFalse(sut.priceViewModel.isValid)
    }

    func testPriceText_withZero_setsIsPriceCorrectToFalse() {
        sut.priceViewModel.text = "0"
        XCTAssertFalse(sut.priceViewModel.isValid)
    }

    func testPriceText_withEmptyString_setsCanConfirmToFalse() {
        sut.priceViewModel.text = ""
        XCTAssertFalse(sut.canConfirm)
    }

    func testPriceText_withZero_setsCanConfirmToFalse() {
        sut.priceViewModel.text = "0"
        XCTAssertFalse(sut.canConfirm)
    }

    func testPriceText_withInvalidString_setsIsPriceCorrectToFalse() {
        sut.priceViewModel.text = "invalid string"
        XCTAssertFalse(sut.priceViewModel.isValid)
    }

    func testPriceText_withoutFractionDigits_setsIsPriceCorrectToTrue() {
        sut.priceViewModel.text = "1"
        XCTAssertTrue(sut.priceViewModel.isValid)

        sut.priceViewModel.text = "1."
        XCTAssertTrue(sut.priceViewModel.isValid)
    }

    func testPriceText_withTwoFractionDigits_setsIsPriceCorrectToTrue() {
        sut.priceViewModel.text = ".99"
        XCTAssertTrue(sut.priceViewModel.isValid)
    }

    func testPriceText_withThreeFractionDigits_setsIsPriceCorrectToFalse() {
        sut.priceViewModel.text = ".999"
        XCTAssertFalse(sut.priceViewModel.isValid)
    }

    func testPriceText_withFiveIntegerDigits_setsIsPriceCorrectToTrue() {
        sut.priceViewModel.text = "12345"
        XCTAssertTrue(sut.priceViewModel.isValid)

        sut.priceViewModel.text = "12345.67"
        XCTAssertTrue(sut.priceViewModel.isValid)
    }

    func testPriceText_withSixIntegerDigits_setsIsPriceCorrectToFalse() {
        sut.priceViewModel.text = "123456"
        XCTAssertFalse(sut.priceViewModel.isValid)

        sut.priceViewModel.text = "123456.78"
        XCTAssertFalse(sut.priceViewModel.isValid)
    }
}
