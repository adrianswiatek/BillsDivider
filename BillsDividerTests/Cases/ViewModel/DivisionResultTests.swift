@testable import BillsDivider
import XCTest

class DivisionResultTests: XCTestCase {
    func testDebtAmount_noDebtCase_returnsZero() {
        let sut: DivisionResult = .noDebt
        XCTAssertEqual(sut.debtAmount, 0)
    }

    private func buyer(_ number: Int) -> Buyer {
        .person(.withGeneratedName(forNumber: number))
    }

    func testDebtAmount_debtCase_returnsGivenAmount() {
        let zeroAmountCase: DivisionResult = .debt(lender: buyer(1), debtor: buyer(1), amount: 0)
        XCTAssertEqual(zeroAmountCase.debtAmount, 0)

        let oneAmountCase: DivisionResult = .debt(lender: buyer(1), debtor: buyer(1), amount: 1)
        XCTAssertEqual(oneAmountCase.debtAmount, 1)

        let oneFifthyCase: DivisionResult = .debt(lender: buyer(1), debtor: buyer(1), amount: 1.5)
        XCTAssertEqual(oneFifthyCase.debtAmount, 1.5)
    }

    func testEquals_twoNoDebtCases_returnsTrue() {
        XCTAssertTrue(DivisionResult.noDebt == DivisionResult.noDebt)
    }

    func testEquals_oneNoDebtCaseAndOneDebtCase_returnsFalse() {
        let first: DivisionResult = .noDebt
        let second: DivisionResult = .debt(lender: buyer(1), debtor: buyer(1), amount: 0)

        XCTAssertFalse(first == second)
        XCTAssertFalse(second == first)
    }

    func testEqualsOperator_twoIdenticalNoDebtCases_returnsTrue() {
        let first: DivisionResult = .debt(lender: buyer(1), debtor: buyer(1), amount: 0)
        let second: DivisionResult = .debt(lender: buyer(1), debtor: buyer(1), amount: 0)

        XCTAssertTrue(first == second)
        XCTAssertTrue(second == first)
    }

    func testEqualsOperator_twoNoDebtCasesWithDifferentLenders_returnsFalse() {
        let first: DivisionResult = .debt(lender:  buyer(1), debtor: buyer(1), amount: 0)
        let second: DivisionResult = .debt(lender: buyer(2), debtor: buyer(1), amount: 0)

        XCTAssertFalse(first == second)
        XCTAssertFalse(second == first)
    }

    func testEqualsOperator_twoNoDebtCasesWithDifferentDebtors_returnsFalse() {
        let first: DivisionResult = .debt(lender:  buyer(1), debtor: buyer(1), amount: 0)
        let second: DivisionResult = .debt(lender: buyer(1), debtor: buyer(2), amount: 0)

        XCTAssertFalse(first == second)
        XCTAssertFalse(second == first)
    }

    func testEqualsOperator_twoNoDebtCasesWithDifferentAmount_returnsFalse() {
        let first: DivisionResult = .debt(lender:  buyer(1), debtor: buyer(1), amount: 0)
        let second: DivisionResult = .debt(lender: buyer(1), debtor: buyer(1), amount: 1)

        XCTAssertFalse(first == second)
        XCTAssertFalse(second == first)
    }
}
