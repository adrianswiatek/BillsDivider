@testable import BillsDivider_Model
import XCTest

class PositionsDividerTests: XCTestCase {
    private var sut: PositionsDivider!
    private var people: People!

    private var firstPerson: Person {
        people[0]
    }

    private var secondPerson: Person {
        people[1]
    }

    override func setUp() {
        super.setUp()
        people = .fromArray([.withGeneratedName(forNumber: 1), .withGeneratedName(forNumber: 2)])
        sut = PositionsDivider()
    }

    override func tearDown() {
        sut = nil
        people = nil
        super.tearDown()
    }

    func testDivide_withPeopleCountLessThanTwo_returnsNoDebtResult() {
        let resultForZeroPeople = sut.divide([], between: .empty)
        XCTAssertEqual(resultForZeroPeople, .noDebt)

        let resultForOnePerson = sut.divide([], between: .fromPerson(.withGeneratedName(forNumber: 1)))
        XCTAssertEqual(resultForOnePerson, .noDebt)
    }

    func testDivide_withEmptyList_returnNoDebtResult() {
        let positions: [ReceiptPosition] = []
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .noDebt)
    }

    func testDivide_withEmptyPosition_returnsNoDebtResult() {
        let positions: [ReceiptPosition] = [.empty]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .noDebt)
    }

    func testDivide_withZeroAmountPositions_returnNoDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 0, buyer: .person(firstPerson), owner: .person(firstPerson)),
            .init(amount: 0, buyer: .person(firstPerson), owner: .person(secondPerson)),
            .init(amount: 0, buyer: .person(secondPerson), owner: .person(firstPerson)),
            .init(amount: 0, buyer: .person(secondPerson), owner: .person(secondPerson))
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .noDebt)
    }

    func testDivide_withBuyerAndOwnerTheSame_returnsNoDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 0, buyer: .person(firstPerson), owner: .person(firstPerson)),
            .init(amount: 1, buyer: .person(firstPerson), owner: .person(firstPerson)),
            .init(amount: 0, buyer: .person(secondPerson), owner: .person(secondPerson)),
            .init(amount: 1, buyer: .person(secondPerson), owner: .person(secondPerson))
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .noDebt)
    }

    func testDivide_withBuyerSetToFirstPersonAndOwnerSetToSecondPerson_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson))
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(firstPerson), debtor: .person(secondPerson), amount: 1))
    }

    func testDivide_withBuyerSetToSecondPersonAndOwnerSetToFirstPerson_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(secondPerson), owner: .person(firstPerson))
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(secondPerson), debtor: .person(firstPerson), amount: 1))
    }

    func testDivide_withBuyerSetToFirstPersonAndOwnerSetToAll_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .all)
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(firstPerson), debtor: .person(secondPerson), amount: 0.5))
    }

    func testDivide_withBuyerSetToSecondPersonAndOwnerSetToAll_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(secondPerson), owner: .all)
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(secondPerson), debtor: .person(firstPerson), amount: 0.5))
    }

    func testDivide_debtAndNoDebtItemsWithBuyerSetToFirstPersonAndOwnerSetToSecondPerson_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson)),
            .empty
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(firstPerson), debtor: .person(secondPerson), amount: 1))
    }

    func testDivide_noDebtAndDebtItemsWithbuyerSetToFirstPersonAndOwnerSetToSecondPerson_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .empty,
            .init(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson))
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(firstPerson), debtor: .person(secondPerson), amount: 1))
    }

    func testDivide_twoDebtItemsWithBuyerSetToFirstPersonAndOwnerSetToSecondPerson_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson)),
            .init(amount: 2, buyer: .person(firstPerson), owner: .person(secondPerson))
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(firstPerson), debtor: .person(secondPerson), amount: 3))
    }

    func testDivide_twoDebtItemsWithBuyerSetToFirstPersonAndOwnerSetToAll_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .all),
            .init(amount: 2, buyer: .person(firstPerson), owner: .all)
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(firstPerson), debtor: .person(secondPerson), amount: 1.5))
    }

    func testDivide_twoDebtItemsWithMixedBuyerOwnerAndAmount_returnsDebtResult() {
        var positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson)),
            .init(amount: 2, buyer: .person(secondPerson), owner: .person(firstPerson))
        ]
        var result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(secondPerson), debtor: .person(firstPerson), amount: 1))

        positions = [
            .init(amount: 2, buyer: .person(firstPerson), owner: .person(secondPerson)),
            .init(amount: 1, buyer: .person(secondPerson), owner: .person(firstPerson))
        ]
        result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(firstPerson), debtor: .person(secondPerson), amount: 1))
    }

    func testDivide_twoDebtItemsWithMixedBuyerOwnerAndEqualAmount_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson)),
            .init(amount: 1, buyer: .person(secondPerson), owner: .person(firstPerson))
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .noDebt)
    }

    func testDivide_twoDebtItemsWithMixedBuyerOwnerSetToAllAndEqualAmount_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .all),
            .init(amount: 1, buyer: .person(secondPerson), owner: .all)
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .noDebt)
    }

    func testDivide_twoDebtItemsWithMixedBuyerOwnerSetToAllAndDifferentAmount_returnsDebtResult() {
        var positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .all),
            .init(amount: 2, buyer: .person(secondPerson), owner: .all)
        ]
        var result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(secondPerson), debtor: .person(firstPerson), amount: 0.5))

        positions = [
            .init(amount: 2, buyer: .person(firstPerson), owner: .all),
            .init(amount: 1, buyer: .person(secondPerson), owner: .all)
        ]
        result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(firstPerson), debtor: .person(secondPerson), amount: 0.5))
    }

    func testDivide_twoDebtItemsWithBuyerSetToFirstPersonMixedOwnersAndEqualAmount_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson)),
            .init(amount: 1, buyer: .person(firstPerson), owner: .all)
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(firstPerson), debtor: .person(secondPerson), amount: 1.5))
    }

    func testDivide_twoDebtItemsWithBuyerSetToFirstPersonMixedOwnersAndDifferentAmount_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson)),
            .init(amount: 2, buyer: .person(firstPerson), owner: .all)
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(firstPerson), debtor: .person(secondPerson), amount: 2))
    }

    func testDivide_twoDebtItemsWithBuyerSetToNotMeMixedOwnersAndEqualAmount_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(secondPerson), owner: .person(firstPerson)),
            .init(amount: 1, buyer: .person(secondPerson), owner: .all)
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(secondPerson), debtor: .person(firstPerson), amount: 1.5))
    }

    func testDivide_twoDebtItemsWithBuyerSetToNotMeMixedOwnersAndDifferentAmount_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(secondPerson), owner: .person(firstPerson)),
            .init(amount: 2, buyer: .person(secondPerson), owner: .all)
        ]
        let result = sut.divide(positions, between: people)
        XCTAssertEqual(result, .debt(lender: .person(secondPerson), debtor: .person(firstPerson), amount: 2))
    }
}
