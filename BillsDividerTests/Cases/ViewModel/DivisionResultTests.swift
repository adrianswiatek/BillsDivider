@testable import BillsDivider
import XCTest

class DivisionResultTests: XCTestCase {
    private let buyers: [Buyer] = [
        .person(.withGeneratedName(forNumber: 1)),
        .person(.withGeneratedName(forNumber: 2))
    ]

    private func buyer(_ number: Int) -> Buyer {
        buyers[number - 1]
    }

    func testDebtAmount_noDebtCase_returnsZero() {
        let sut: DivisionResult = .noDebt
        XCTAssertEqual(sut.debtAmount, 0)
    }

    func testDebtAmount_debtCase_returnsGivenAmount() {
        let zeroAmountCase: DivisionResult = .debt(lender: buyers[0], debtor: buyers[0], amount: 0)
        XCTAssertEqual(zeroAmountCase.debtAmount, 0)

        let oneAmountCase: DivisionResult = .debt(lender: buyers[0], debtor: buyers[0], amount: 1)
        XCTAssertEqual(oneAmountCase.debtAmount, 1)

        let oneFifthyCase: DivisionResult = .debt(lender: buyers[0], debtor: buyers[0], amount: 1.5)
        XCTAssertEqual(oneFifthyCase.debtAmount, 1.5)
    }

    func testEquals_twoNoDebtCases_returnsTrue() {
        XCTAssertTrue(DivisionResult.noDebt == DivisionResult.noDebt)
    }

    func testEquals_oneNoDebtCaseAndOneDebtCase_returnsFalse() {
        let first: DivisionResult = .noDebt
        let second: DivisionResult = .debt(lender: buyers[0], debtor: buyers[0], amount: 0)

        XCTAssertFalse(first == second)
        XCTAssertFalse(second == first)
    }

    func testEquals_twoIdenticalDebtCases_returnsTrue() {
        let first: DivisionResult = .debt(lender: buyers[0], debtor: buyers[0], amount: 0)
        let second: DivisionResult = .debt(lender: buyers[0], debtor: buyers[0], amount: 0)

        XCTAssertTrue(first == second)
        XCTAssertTrue(second == first)
    }

    func testEquals_twoDebtCasesWithDifferentLenders_returnsFalse() {
        let first: DivisionResult = .debt(lender: buyers[0], debtor: buyers[0], amount: 0)
        let second: DivisionResult = .debt(lender: buyers[1], debtor: buyers[0], amount: 0)

        XCTAssertFalse(first == second)
        XCTAssertFalse(second == first)
    }

    func testEquals_twoDebtCasesWithDifferentDebtors_returnsFalse() {
        let first: DivisionResult = .debt(lender: buyers[0], debtor: buyers[0], amount: 0)
        let second: DivisionResult = .debt(lender: buyers[0], debtor: buyers[1], amount: 0)

        XCTAssertFalse(first == second)
        XCTAssertFalse(second == first)
    }

    func testEquals_twoDebtCasesWithDifferentAmount_returnsFalse() {
        let first: DivisionResult = .debt(lender: buyers[0], debtor: buyers[0], amount: 0)
        let second: DivisionResult = .debt(lender: buyers[0], debtor: buyers[0], amount: 1)

        XCTAssertFalse(first == second)
        XCTAssertFalse(second == first)
    }
}
