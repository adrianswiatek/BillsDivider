@testable import BillsDivider
import XCTest

class DivisionResultTests: XCTestCase {
    func testDebtAmount_noDebtCase_returnsZero() {
        let sut: DivisionResult = .noDebt
        XCTAssertEqual(sut.debtAmount, 0)
    }

    func testDebtAmount_debtCase_returnsGivenAmount() {
        let zeroAmountCase: DivisionResult = .debt(lender: .me, debtor: .me, amount: 0)
        XCTAssertEqual(zeroAmountCase.debtAmount, 0)

        let oneAmountCase: DivisionResult = .debt(lender: .me, debtor: .me, amount: 1)
        XCTAssertEqual(oneAmountCase.debtAmount, 1)

        let oneFifthyCase: DivisionResult = .debt(lender: .me, debtor: .me, amount: 1.5)
        XCTAssertEqual(oneFifthyCase.debtAmount, 1.5)
    }

    func testEqualsOperator_twoNoDebtCases_returnsTrue() {
        XCTAssertTrue(DivisionResult.noDebt == DivisionResult.noDebt)
    }

    func testEqualsOperator_oneNoDebtCaseAndOneDebtCase_returnsFalse() {
        let first: DivisionResult = .noDebt
        let second: DivisionResult = .debt(lender: .me, debtor: .me, amount: 0)
        XCTAssertFalse(first == second)
        XCTAssertFalse(second == first)
    }

    func testEqualsOperator_twoIdenticalNoDebtCases_returnsTrue() {
        let first: DivisionResult = .debt(lender: .me, debtor: .me, amount: 0)
        let second: DivisionResult = .debt(lender: .me, debtor: .me, amount: 0)
        XCTAssertTrue(first == second)
    }

    func testEqualsOperator_twoNoDebtCasesWithDifferentLenders_returnsFalse() {
        let first: DivisionResult = .debt(lender: .me, debtor: .me, amount: 0)
        let second: DivisionResult = .debt(lender: .notMe, debtor: .me, amount: 0)
        XCTAssertFalse(first == second)
    }

    func testEqualsOperator_twoNoDebtCasesWithDifferentDebtors_returnsFalse() {
        let first: DivisionResult = .debt(lender: .me, debtor: .me, amount: 0)
        let second: DivisionResult = .debt(lender: .me, debtor: .notMe, amount: 0)
        XCTAssertFalse(first == second)
    }

    func testEqualsOperator_twoNoDebtCasesWithDifferentAmount_returnsFalse() {
        let first: DivisionResult = .debt(lender: .me, debtor: .me, amount: 0)
        let second: DivisionResult = .debt(lender: .me, debtor: .me, amount: 1)
        XCTAssertFalse(first == second)
    }
}
