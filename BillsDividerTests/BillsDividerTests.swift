@testable import BillsDivider
import XCTest

class BillsDividerTests: XCTestCase {
    private var sut: BillsDivider!

    override func setUp() {
        super.setUp()
        sut = BillsDivider()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testDivide_withEmptyList_returnNoDebtResult() {
        let positions: [ReceiptPosition] = []
        let result = sut.divide(positions)
        XCTAssertEqual(result, .noDebt)
    }

    func testDivide_withEmptyPosition_returnsNoDebtResult() {
        let positions: [ReceiptPosition] = [.empty]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .noDebt)
    }

    func testDivide_withZeroAmountPositions_returnNoDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 0, buyer: .me, owner: .me),
            .init(amount: 0, buyer: .me, owner: .notMe),
            .init(amount: 0, buyer: .notMe, owner: .me),
            .init(amount: 0, buyer: .notMe, owner: .notMe)
        ]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .noDebt)
    }

    func testDivide_withBuyerAndOwnerTheSame_returnsNoDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 0, buyer: .me, owner: .me),
            .init(amount: 1, buyer: .me, owner: .me),
            .init(amount: 0, buyer: .notMe, owner: .notMe),
            .init(amount: 1, buyer: .notMe, owner: .notMe)
        ]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .noDebt)
    }

    func testDivide_withBuyerSetToMeAndOwnerSetToNotMe_returnsDebtResult() {
        let positions: [ReceiptPosition] = [.init(amount: 1, buyer: .me, owner: .notMe)]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .me, debtor: .notMe, amount: 1))
    }

    func testDivide_withBuyerSetToNotMeAndOwnerSetToMe_returnsDebtResult() {
        let positions: [ReceiptPosition] = [.init(amount: 1, buyer: .notMe, owner: .me)]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .notMe, debtor: .me, amount: 1))
    }

    func testDivide_withBuyerSetToMeAndOwnerSetToAll_returnsDebtResult() {
        let positions: [ReceiptPosition] = [.init(amount: 1, buyer: .me, owner: .all)]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .me, debtor: .notMe, amount: 0.5))
    }

    func testDivide_withBuyerSetToNotMeAndOwnerSetToAll_returnsDebtResult() {
        let positions: [ReceiptPosition] = [.init(amount: 1, buyer: .notMe, owner: .all)]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .notMe, debtor: .me, amount: 0.5))
    }

    func testDivide_debtAndNoDebtItemsWithBuyerSetToMeAndOwnerSetToNotMe_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .me, owner: .notMe),
            .empty
        ]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .me, debtor: .notMe, amount: 1))
    }

    func testDivide_noDebtAndDebtItemsWithbuyerSetToMeAndOwnerSetToNotMe_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .empty,
            .init(amount: 1, buyer: .me, owner: .notMe)
        ]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .me, debtor: .notMe, amount: 1))
    }

    func testDivide_twoDebtItemsWithBuyerSetToMeAndOwnerSetToNotMe_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .me, owner: .notMe),
            .init(amount: 2, buyer: .me, owner: .notMe)
        ]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .me, debtor: .notMe, amount: 3))
    }

    func testDivide_twoDebtItemsWithBuyerSetToMeAndOwnerSetToAll_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .me, owner: .all),
            .init(amount: 2, buyer: .me, owner: .all)
        ]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .me, debtor: .notMe, amount: 1.5))
    }

    func testDivide_twoDebtItemsWithMixedBuyerOwnerAndAmount_returnsDebtResult() {
        var positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .me, owner: .notMe),
            .init(amount: 2, buyer: .notMe, owner: .me)
        ]
        var result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .notMe, debtor: .me, amount: 1))

        positions = [
            .init(amount: 2, buyer: .me, owner: .notMe),
            .init(amount: 1, buyer: .notMe, owner: .me)
        ]
        result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .me, debtor: .notMe, amount: 1))
    }

    func testDivide_twoDebtItemsWithMixedBuyerOwnerAndEqualAmount_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .me, owner: .notMe),
            .init(amount: 1, buyer: .notMe, owner: .me)
        ]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .noDebt)
    }

    func testDivide_twoDebtItemsWithMixedBuyerOwnerSetToAllAndEqualAmount_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .me, owner: .all),
            .init(amount: 1, buyer: .notMe, owner: .all)
        ]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .noDebt)
    }

    func testDivide_twoDebtItemsWithMixedBuyerOwnerSetToAllAndDifferentAmount_returnsDebtResult() {
        var positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .me, owner: .all),
            .init(amount: 2, buyer: .notMe, owner: .all)
        ]
        var result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .notMe, debtor: .me, amount: 0.5))

        positions = [
            .init(amount: 2, buyer: .me, owner: .all),
            .init(amount: 1, buyer: .notMe, owner: .all)
        ]
        result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .me, debtor: .notMe, amount: 0.5))
    }

    func testDivide_twoDebtItemsWithBuyerSetToMeMixedOwnersAndEqualAmount_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .me, owner: .notMe),
            .init(amount: 1, buyer: .me, owner: .all)
        ]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .me, debtor: .notMe, amount: 1.5))
    }

    func testDivide_twoDebtItemsWithBuyerSetToMeMixedOwnersAndDifferentAmount_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .me, owner: .notMe),
            .init(amount: 2, buyer: .me, owner: .all)
        ]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .me, debtor: .notMe, amount: 2))
    }

    func testDivide_twoDebtItemsWithBuyerSetToNotMeMixedOwnersAndEqualAmount_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .notMe, owner: .me),
            .init(amount: 1, buyer: .notMe, owner: .all)
        ]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .notMe, debtor: .me, amount: 1.5))
    }

    func testDivide_twoDebtItemsWithBuyerSetToNotMeMixedOwnersAndDifferentAmount_returnsDebtResult() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .notMe, owner: .me),
            .init(amount: 2, buyer: .notMe, owner: .all)
        ]
        let result = sut.divide(positions)
        XCTAssertEqual(result, .debt(lender: .notMe, debtor: .me, amount: 2))
    }
}
