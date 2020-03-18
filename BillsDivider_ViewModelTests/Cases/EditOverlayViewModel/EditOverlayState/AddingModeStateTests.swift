@testable import BillsDivider_Model
@testable import BillsDivider_ViewModel
import Combine
import XCTest

class AddingModeStateTests: XCTestCase {
    private var sut: AddingModeState!
    private var position: ReceiptPosition!
    private var viewModel: EditOverlayViewModel!
    private var priceViewModel: PriceViewModel!
    private var discountViewModel: DiscountViewModel!
    private var discountPopoverViewModel: DiscountPopoverViewModel!

    private var people: People!

    private var subscriptions: [AnyCancellable]!

    override func setUp() {
        super.setUp()

        people = .fromArray([.withGeneratedName(forNumber: 1), .withGeneratedName(forNumber: 2)])
        position = .init(amount: 1, buyer: .person(people[0]), owner: .person(people[1]))
        sut = .init(receiptPosition: position)
        prepareViewModels()
        subscriptions = []
    }

    override func tearDown() {
        subscriptions = nil
        cleanViewModels()
        sut = nil
        position = nil
        people = nil
        super.tearDown()
    }

    private func prepareViewModels() {
        let decimalParser = DecimalParser()
        let numberFormatter = NumberFormatter.twoFractionDigitsNumberFormatter
        let peopleService = PeopleServiceFake()

        discountPopoverViewModel = .init(decimalParser: decimalParser, numberFormatter: numberFormatter)
        discountViewModel = .init(discountPopoverViewModel: discountPopoverViewModel, decimalParser: decimalParser)
        priceViewModel = .init(decimalParser: decimalParser, numberFormatter: numberFormatter)
        viewModel = .init(
            presenting: .constant(true),
            priceViewModel: priceViewModel,
            discountViewModel: discountViewModel,
            discountPopoverViewModel: discountPopoverViewModel,
            editOverlayState: sut,
            peopleService: peopleService,
            decimalParser: decimalParser
        )

        peopleService.updatePeople(.fromArray([.withGeneratedName(forNumber: 1), .withGeneratedName(forNumber: 2)]))
    }

    private func cleanViewModels() {
        viewModel = nil
        priceViewModel = nil
        discountViewModel = nil
        discountPopoverViewModel = nil
    }

    func testPageName_returnsEditPosition() {
        XCTAssertEqual(sut.pageName, "Add position")
    }

    func testInit_withReceiptPosition_setsGivenReceiptPosition() {
        XCTAssertEqual(sut.receiptPosition, position)
    }

    func testSetViewModel_setsPriceTextOnGivenViewModel() {
        sut.set(viewModel: viewModel)
        XCTAssertEqual(priceViewModel.text, "")
    }

    func testSetViewModel_setsAddAnotherOnGivenViewModel() {
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.addAnother, true)
    }

    func testSetViewModel_withReceiptPosition_setsGetInitialBuyerToReceiptPositionsBuyer() {
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.getInitialBuyer?(), position.buyer)
    }

    func testSetViewModel_withEmptyReceiptPosition_setsGetInitialBuyerToFirstBuyer() {
        sut = AddingModeState(receiptPosition: .empty)
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.getInitialBuyer?(), viewModel.buyers[0])
    }

    func testSetViewModel_withReceiptPosition_setsGetInitialOwnerToReceiptPositionOwner() {
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.getInitialOwner?(), position.owner)
    }

    func testSetViewModel_withEmptyReceiptPosition_setsGetInitialOwnerToAll() {
        sut = AddingModeState(receiptPosition: .empty)
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.getInitialOwner?(), .all)
    }

    func testConfirmDidTap_sendsGivenPositionThroughPositionAdded() {
        let expectation = self.expectation(description: "Receipt position is added.")
        var result: ReceiptPosition?
        viewModel.positionAdded
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        let addedPosition =
            ReceiptPosition(amount: 2, buyer: .person(people[0]), owner: .person(people[1]))

        sut.confirmDidTap(with: addedPosition, in: viewModel)

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(result, addedPosition)
    }
}
