@testable import BillsDivider
import Combine
import Foundation
import XCTest

class SummaryViewModelTests: XCTestCase {
    private var subscriptions: [AnyCancellable]!

    override func setUp() {
        super.setUp()
        subscriptions = []
    }

    // MARK: - Helpers
    private func summaryViewModel(
        with positions: AnyPublisher<[ReceiptPosition], Never>
    ) -> SummaryViewModel {
        SummaryViewModel(
            positions: positions,
            billsDivider: .init(),
            numberFormatter: numberFormatter
        )
    }

    private var numberFormatter: NumberFormatter {
        .twoFracionDigitsNumberFormatter
    }

    private var emptyPositions: AnyPublisher<[ReceiptPosition], Never> {
        Empty<[ReceiptPosition], Never>().eraseToAnyPublisher()
    }

    // MARK: - Tests
    func testInit_leftSidedBuyerSetToMe() {
        XCTAssertEqual(summaryViewModel(with: emptyPositions).leftSidedBuyer, .me)
    }

    func testInit_rightSidedBuyerSetToNotMe() {
        XCTAssertEqual(summaryViewModel(with: emptyPositions).rightSidedBuyer, .notMe)
    }

    func testInit_formattedDebtReturnsFormattedZero() {
        let expected = numberFormatter.format(value: 0)
        let result = summaryViewModel(with: emptyPositions).formattedDebt
        XCTAssertEqual(result, expected)
    }

    func testInit_formattedDirectionSetToEqual() {
        XCTAssertEqual(summaryViewModel(with: emptyPositions).formattedDirection, "equal")
    }

    func testFormattedDirection_whenNoDebtDivisionResult_returnsEqual() {
        let position = ReceiptPosition(amount: 0, buyer: .me, owner: .notMe)
        let positions = CurrentValueSubject<[ReceiptPosition], Never>([position])
        let sut = summaryViewModel(with: positions.eraseToAnyPublisher())
        XCTAssertEqual(sut.formattedDirection, "equal")
    }

    func testFormattedDirection_whenDebtDivisionResultAndLenderAsLeftSidedBuyer_returnsArrowLeft() {
        let position = ReceiptPosition(amount: 1, buyer: .me, owner: .notMe)
        let positions = CurrentValueSubject<[ReceiptPosition], Never>([position])
        let sut = summaryViewModel(with: positions.eraseToAnyPublisher())
        XCTAssertEqual(sut.formattedDirection, "arrow.left")
    }

    func testFormattedDirection_whenDebtDivisionResultAndLenderAsRightSidedBuyer_returnsArrowRight() {
        let position = ReceiptPosition(amount: 1, buyer: .notMe, owner: .me)
        let positions = CurrentValueSubject<[ReceiptPosition], Never>([position])
        let sut = summaryViewModel(with: positions.eraseToAnyPublisher())
        XCTAssertEqual(sut.formattedDirection, "arrow.right")
    }

    func testObject_whenPositionSend_objectShouldChange() {
        let positions = PassthroughSubject<[ReceiptPosition], Never>()
        let sut = summaryViewModel(with: positions.eraseToAnyPublisher())
        let exp = expectation(description: "object should change after sending position")
        sut.objectWillChange.sink { exp.fulfill() }.store(in: &subscriptions)

        positions.send([ReceiptPosition(amount: 0, buyer: .me, owner: .notMe)])

        wait(for: [exp], timeout: 1)
    }

    func testFormattedDebt_whenDebtPositionSend_shouldReturnFormattedValue() {
        let position = ReceiptPosition(amount: 1, buyer: .me, owner: .notMe)
        let positions = CurrentValueSubject<[ReceiptPosition], Never>([position])
        let sut = summaryViewModel(with: positions.eraseToAnyPublisher())
        XCTAssertEqual(sut.formattedDebt, numberFormatter.format(value: 1))
    }
}
