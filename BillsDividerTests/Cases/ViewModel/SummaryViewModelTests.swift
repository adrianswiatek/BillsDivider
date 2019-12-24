@testable import BillsDivider
import Combine
import Foundation
import XCTest

class SummaryViewModelTests: XCTestCase {
    private var subscriptions: [AnyCancellable]!
    private var peopleService: PeopleServiceFake!

    override func setUp() {
        super.setUp()
        peopleService = PeopleServiceFake()
        subscriptions = []
    }

    override func tearDown() {
        subscriptions = nil
        peopleService = nil
        super.tearDown()
    }

    // MARK: - Helpers
    private func summaryViewModel(_ positions: AnyPublisher<[ReceiptPosition], Never>) -> SummaryViewModel {
        .init(positions: positions, peopleService: peopleService, divider: .init(), numberFormatter: numberFormatter)
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
        XCTAssertEqual(sut.formattedLeftSidedBuyer, people[0].name)
    }

    func testInit_rightSidedBuyerSetToSecondPerson() {
        let people: [Person] = [.withGeneratedName(forNumber: 1), .withGeneratedName(forNumber: 2)]
        let sut = summaryViewModel(emptyPositions)
        peopleService.updatePeople(people)
        XCTAssertEqual(sut.formattedRightSidedBuyer, people[1].name)
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
        let position = ReceiptPosition(amount: 0, buyer: .me, owner: .notMe)
        let positions = CurrentValueSubject<[ReceiptPosition], Never>([position])
        let sut = summaryViewModel(positions.eraseToAnyPublisher())
        XCTAssertEqual(sut.formattedDirection, "equal")
    }

    func testFormattedDirection_whenDebtDivisionResultAndLenderAsLeftSidedBuyer_returnsArrowLeft() {
        let position = ReceiptPosition(amount: 1, buyer: .me, owner: .notMe)
        let positions = CurrentValueSubject<[ReceiptPosition], Never>([position])
        let sut = summaryViewModel(positions.eraseToAnyPublisher())
        XCTAssertEqual(sut.formattedDirection, "arrow.left")
    }

    func testFormattedDirection_whenDebtDivisionResultAndLenderAsRightSidedBuyer_returnsArrowRight() {
        let position = ReceiptPosition(amount: 1, buyer: .notMe, owner: .me)
        let positions = CurrentValueSubject<[ReceiptPosition], Never>([position])
        let sut = summaryViewModel(positions.eraseToAnyPublisher())
        XCTAssertEqual(sut.formattedDirection, "arrow.right")
    }

    func testObject_whenPositionSend_objectShouldChange() {
        let positions = PassthroughSubject<[ReceiptPosition], Never>()
        let sut = summaryViewModel(positions.eraseToAnyPublisher())
        let exp = expectation(description: "object should change after sending position")
        sut.objectWillChange.sink { exp.fulfill() }.store(in: &subscriptions)

        positions.send([ReceiptPosition(amount: 0, buyer: .me, owner: .notMe)])

        wait(for: [exp], timeout: 1)
    }

    func testFormattedDebt_whenDebtPositionSend_shouldReturnFormattedValue() {
        let position = ReceiptPosition(amount: 1, buyer: .me, owner: .notMe)
        let positions = CurrentValueSubject<[ReceiptPosition], Never>([position])
        let sut = summaryViewModel(positions.eraseToAnyPublisher())
        XCTAssertEqual(sut.formattedDebt, numberFormatter.format(value: 1))
    }
}
