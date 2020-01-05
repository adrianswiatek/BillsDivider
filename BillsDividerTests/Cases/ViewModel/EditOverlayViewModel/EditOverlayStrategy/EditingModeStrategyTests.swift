@testable import BillsDivider
import Combine
import XCTest

class EditingModeStrategyTests: XCTestCase {
    private var sut: EditingModeStrategy!
    private var position: ReceiptPosition!
    private var subscriptions: [AnyCancellable]!

    override func setUp() {
        super.setUp()
        position = ReceiptPosition(amount: 1, buyer: .person(.withName("My name")), owner: .all)
        sut = EditingModeStrategy(receiptPosition: position, numberFormatter: numberFormatter)
        subscriptions = []
    }

    override func tearDown() {
        sut = nil
        subscriptions = nil
        super.tearDown()
    }

    private var numberFormatter: NumberFormatter {
        .twoFractionDigitsNumberFormatter
    }

    private var viewModel: EditOverlayViewModel {
        EditOverlayViewModel(
            presenting: .constant(true),
            editOverlayStrategy: sut,
            peopleService: PeopleServiceFake(),
            numberFormatter: numberFormatter
        )
    }

    func testPageName_returnsEditPosition() {
        XCTAssertEqual(sut.pageName, "Edit position")
    }

    func testShowAddanother_returnsFalse() {
        XCTAssertFalse(sut.showAddAnother)
    }

    func testInit_withReceiptPosition_setsGivenReceiptPosition() {
        XCTAssertEqual(sut.receiptPosition, position)
    }

    func testSetViewModel_setsPriceTextOnGivenViewModel() {
        let viewModel = self.viewModel
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.priceText, numberFormatter.format(value: 1))
    }

    func testSetViewModel_setsAddAnotherOnGivenViewModel() {
        let viewModel = self.viewModel
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.addAnother, false)
    }

    func testSetViewModel_setsGetInitialBuyerToReceiptPositionsBuyer() {
        let viewModel = self.viewModel
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.getInitialBuyer?(), position.buyer)
    }

    func testSetViewModel_setsGetInitialOwnerToReceiptPositionOwner() {
        let viewModel = self.viewModel
        sut.set(viewModel: viewModel)
        XCTAssertEqual(viewModel.getInitialOwner?(), position.owner)
    }

    func testConfirmDidTap_sendsGivenPositionThroughPositionEdited() {
        let viewModel = self.viewModel

        let expectation = self.expectation(description: "Receipt position is edited.")
        var result: ReceiptPosition?
        viewModel.positionEdited
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        let updatedPosition = ReceiptPosition(
            id: position.id,
            amount: 2,
            buyer: .person(.withName("Updated buyer")),
            owner: .person(.withName("Updated owner"))
        )

        sut.confirmDidTap(with: updatedPosition, in: viewModel)

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(result, updatedPosition)
    }
}
