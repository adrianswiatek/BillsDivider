@testable import BillsDivider_Model
@testable import BillsDivider_ViewModel
import Combine
import XCTest

class AddingModeStrategyTests: XCTestCase {
    private var sut: AddingModeStrategy!
    private var position: ReceiptPosition!

    private var people: People!

    private var subscriptions: [AnyCancellable]!

    override func setUp() {
        super.setUp()
        people = .fromArray([.withGeneratedName(forNumber: 1), .withGeneratedName(forNumber: 2)])
        position = ReceiptPosition(amount: 1, buyer: .person(people[0]), owner: .person(people[1]))
        sut = AddingModeStrategy(receiptPosition: position)
        subscriptions = []
    }

    override func tearDown() {
        subscriptions = nil
        sut = nil
        position = nil
        people = nil
        super.tearDown()
    }

    private var numberFormatter: NumberFormatter {
        .twoFractionDigitsNumberFormatter
    }

    private var viewModel: EditOverlayViewModel {
        let peopleService = PeopleServiceFake()

        let viewModel = EditOverlayViewModel(
            presenting: .constant(true),
            editOverlayStrategy: sut,
            peopleService: peopleService,
            numberFormatter: numberFormatter
        )
        peopleService.updatePeople(people)
        return viewModel
    }

    func testPageName_returnsEditPosition() {
        XCTAssertEqual(sut.pageName, "Add position")
    }

    func testInit_withReceiptPosition_setsGivenReceiptPosition() {
        XCTAssertEqual(sut.receiptPosition, position)
    }

    func testSetViewModel_setsPriceTextOnGivenViewModel() {
        let viewModel = self.viewModel
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.priceText, "")
    }

    func testSetViewModel_setsAddAnotherOnGivenViewModel() {
        let viewModel = self.viewModel
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.addAnother, true)
    }

    func testSetViewModel_withReceiptPosition_setsGetInitialBuyerToReceiptPositionsBuyer() {
        let viewModel = self.viewModel
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.getInitialBuyer?(), position.buyer)
    }

    func testSetViewModel_withEmptyReceiptPosition_setsGetInitialBuyerToFirstBuyer() {
        sut = AddingModeStrategy(receiptPosition: .empty)
        let viewModel = self.viewModel
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.getInitialBuyer?(), viewModel.buyers[0])
    }

    func testSetViewModel_withReceiptPosition_setsGetInitialOwnerToReceiptPositionOwner() {
        let viewModel = self.viewModel
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.getInitialOwner?(), position.owner)
    }

    func testSetViewModel_withEmptyReceiptPosition_setsGetInitialOwnerToAll() {
        sut = AddingModeStrategy(receiptPosition: .empty)
        let viewModel = self.viewModel
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.getInitialOwner?(), .all)
    }

    func testConfirmDidTap_sendsGivenPositionThroughPositionAdded() {
        let viewModel = self.viewModel

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
