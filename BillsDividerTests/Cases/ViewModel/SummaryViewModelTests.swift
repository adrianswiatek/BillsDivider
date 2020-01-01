@testable import BillsDivider
import Combine
import Foundation
import XCTest

class SummaryViewModelTests: XCTestCase {
    private var sut: SummaryViewModel!
    private var receiptPositionService: ReceiptPositionService!
    private var peopleService: PeopleServiceFake!
    private var subscriptions: [AnyCancellable]!

    private var people: [Person] = [
        .withGeneratedName(forNumber: 1),
        .withGeneratedName(forNumber: 2)
    ]

    override func setUp() {
        super.setUp()
        peopleService = PeopleServiceFake()
        receiptPositionService = InMemoryReceiptPositionService(peopleService: peopleService)
        sut = SummaryViewModel(
            receiptPositionService: receiptPositionService,
            peopleService: peopleService,
            divider: .init(),
            numberFormatter: numberFormatter
        )
        subscriptions = []
        peopleService.updatePeople(people)
    }

    override func tearDown() {
        subscriptions = nil
        sut = nil
        receiptPositionService = nil
        peopleService = nil
        super.tearDown()
    }

    // MARK: - Helpers
    private func position(withAmount amount: Decimal) -> ReceiptPosition {
        return .init(amount: amount, buyer: .person(people[0]), owner: .person(people[1]))
    }

    private var numberFormatter: NumberFormatter {
        .twoFractionDigitsNumberFormatter
    }

    // MARK: - Tests
    func testInit_leftSidedBuyerSetToFirstPerson() {
        let people: [Person] = [.withGeneratedName(forNumber: 1), .withGeneratedName(forNumber: 2)]
        peopleService.updatePeople(people)
        XCTAssertEqual(sut.leftSidedBuyer.formatted, people[0].name)
    }

    func testInit_rightSidedBuyerSetToSecondPerson() {
        let people: [Person] = [.withGeneratedName(forNumber: 1), .withGeneratedName(forNumber: 2)]
        peopleService.updatePeople(people)
        XCTAssertEqual(sut.rightSidedBuyer.formatted, people[1].name)
    }

    func testInit_formattedDebtReturnsFormattedZero() {
        XCTAssertEqual(sut.formattedDebt, numberFormatter.format(value: 0))
    }

    func testInit_formattedDirectionSetToEqual() {
        XCTAssertEqual(sut.formattedDirection, "equal")
    }

    func testFormattedDirection_whenNoDebtDivisionResult_returnsEqual() {
        XCTAssertEqual(sut.formattedDirection, "equal")
    }

    func testFormattedDirection_whenDebtDivisionResultAndLenderAsLeftSidedBuyer_returnsArrowLeft() {
        let expectation = self.expectation(description: "Position has been sent")

        receiptPositionService.positionsDidUpdate
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &subscriptions)
        receiptPositionService.insert(.init(amount: 1, buyer: .person(people[0]), owner: .person(people[1])))

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(sut.formattedDirection, "arrow.left")
    }

    func testFormattedDirection_whenDebtDivisionResultAndLenderAsRightSidedBuyer_returnsArrowRight() {
        let expectation = self.expectation(description: "Position has been sent")

        receiptPositionService.positionsDidUpdate
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &subscriptions)
        receiptPositionService.insert(.init(amount: 1, buyer: .person(people[1]), owner: .person(people[0])))

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(sut.formattedDirection, "arrow.right")
    }

    func testObject_whenPositionSend_objectShouldChange() {
        let expectation = self.expectation(description: "Position has been sent")

        sut.objectWillChange
            .sink { expectation.fulfill() }
            .store(in: &subscriptions)

        receiptPositionService.insert(position(withAmount: 0))

        wait(for: [expectation], timeout: 1)
    }

    func testFormattedDebt_whenDebtPositionInserted_shouldReturnFormattedValue() {
        let expectation = self.expectation(description: "Position has been sent")

        receiptPositionService.positionsDidUpdate
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &subscriptions)
        receiptPositionService.insert(position(withAmount: 1))

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(sut.formattedDebt, numberFormatter.format(value: 1))
    }
}
