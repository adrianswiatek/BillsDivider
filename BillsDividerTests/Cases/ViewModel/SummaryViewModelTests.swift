@testable import BillsDivider
import Combine
import Foundation
import XCTest

class SummaryViewModelTests: XCTestCase {
    private var receiptPositionService: ReceiptPositionService!
    private var peopleService: PeopleServiceFake!
    private var subscriptions: [AnyCancellable]!

    override func setUp() {
        super.setUp()
        peopleService = PeopleServiceFake()
        receiptPositionService = InMemoryReceiptPositionService(peopleService: peopleService)
        subscriptions = []
    }

    override func tearDown() {
        subscriptions = nil
        receiptPositionService = nil
        peopleService = nil
        super.tearDown()
    }

    // MARK: - Helpers
    private func summaryViewModel(_ positions: AnyPublisher<[ReceiptPosition], Never>) -> SummaryViewModel {
        .init(
            receiptPositionService: receiptPositionService,
            peopleService: peopleService,
            divider: .init(),
            numberFormatter: numberFormatter
        )
    }

    private func position(withAmount amount: Decimal) -> ReceiptPosition {
        .init(
            amount: amount,
            buyer: .person(.withGeneratedName(forNumber: 1)),
            owner: .person(.withGeneratedName(forNumber: 2))
        )
    }

    private var numberFormatter: NumberFormatter {
        .twoFractionDigitsNumberFormatter
    }

    private var emptyPositions: AnyPublisher<[ReceiptPosition], Never> {
        Empty<[ReceiptPosition], Never>().eraseToAnyPublisher()
    }

    // MARK: - Tests
    func testInit_leftSidedBuyerSetToFirstPerson() {
        let people: [Person] = [.withGeneratedName(forNumber: 1), .withGeneratedName(forNumber: 2)]
        let sut = summaryViewModel(emptyPositions)
        peopleService.updatePeople(people)
        XCTAssertEqual(sut.leftSidedBuyer.formatted, people[0].name)
    }

    func testInit_rightSidedBuyerSetToSecondPerson() {
        let people: [Person] = [.withGeneratedName(forNumber: 1), .withGeneratedName(forNumber: 2)]
        let sut = summaryViewModel(emptyPositions)
        peopleService.updatePeople(people)
        XCTAssertEqual(sut.rightSidedBuyer.formatted, people[1].name)
    }

    func testInit_formattedDebtReturnsFormattedZero() {
        let expected = numberFormatter.format(value: 0)
        let result = summaryViewModel(emptyPositions).formattedDebt
        XCTAssertEqual(result, expected)
    }

    func testInit_formattedDirectionSetToEqual() {
        XCTAssertEqual(summaryViewModel(emptyPositions).formattedDirection, "equal")
    }

    func testFormattedDirection_whenNoDebtDivisionResult_returnsEqual() {
        let positions = CurrentValueSubject<[ReceiptPosition], Never>([position(withAmount: 0)])
        let sut = summaryViewModel(positions.eraseToAnyPublisher())
        XCTAssertEqual(sut.formattedDirection, "equal")
    }

    func testFormattedDirection_whenDebtDivisionResultAndLenderAsLeftSidedBuyer_returnsArrowLeft() {
        let positions = CurrentValueSubject<[ReceiptPosition], Never>([position(withAmount: 1)])
        let sut = summaryViewModel(positions.eraseToAnyPublisher())
        XCTAssertEqual(sut.formattedDirection, "arrow.left")
    }

    func testFormattedDirection_whenDebtDivisionResultAndLenderAsRightSidedBuyer_returnsArrowRight() {
        let positions = CurrentValueSubject<[ReceiptPosition], Never>([position(withAmount: 1)])
        let sut = summaryViewModel(positions.eraseToAnyPublisher())
        XCTAssertEqual(sut.formattedDirection, "arrow.right")
    }

    func testObject_whenPositionSend_objectShouldChange() {
        let positions = PassthroughSubject<[ReceiptPosition], Never>()
        let sut = summaryViewModel(positions.eraseToAnyPublisher())
        let exp = expectation(description: "object should change after sending position")
        sut.objectWillChange.sink { exp.fulfill() }.store(in: &subscriptions)

        positions.send([position(withAmount: 0)])

        wait(for: [exp], timeout: 1)
    }

    func testFormattedDebt_whenDebtPositionSend_shouldReturnFormattedValue() {
        let positions = CurrentValueSubject<[ReceiptPosition], Never>([position(withAmount: 1)])
        let sut = summaryViewModel(positions.eraseToAnyPublisher())
        XCTAssertEqual(sut.formattedDebt, numberFormatter.format(value: 1))
    }
}
