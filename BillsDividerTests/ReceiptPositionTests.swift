@testable import BillsDivider
import XCTest

class ReceiptPositionTests: XCTestCase {
    func testEmpty_returnsReceiptPositionWithZeroAmountBuyerSetToMeAndOwnerSetToAll() {
        let sut: ReceiptPosition = .empty
        XCTAssertEqual(sut.amount, 0)
        XCTAssertEqual(sut.buyer, .me)
        XCTAssertEqual(sut.owner, .all)
    }

    func testEquals_theSamePositions_returnsTrue() {
        let position = ReceiptPosition(amount: 1, buyer: .me, owner: .notMe)
        XCTAssertEqual(position, position)
    }

    func testEquals_twoNewButTheSamePositions_returnsTrue() {
        let position1 = ReceiptPosition(amount: 1, buyer: .me, owner: .notMe)
        let position2 = ReceiptPosition(amount: 1, buyer: .me, owner: .notMe)
        XCTAssertEqual(position1, position2)
    }

    func testEquals_twoPositionsWithDifferentAmount_returnsFalse() {
        let position1 = ReceiptPosition(amount: 1, buyer: .me, owner: .notMe)
        let position2 = ReceiptPosition(amount: 2, buyer: .me, owner: .notMe)
        XCTAssertNotEqual(position1, position2)
    }

    func testEquals_twoPositionsWithDifferentBuyer_returnsFalse() {
        let position1 = ReceiptPosition(amount: 1, buyer: .me, owner: .notMe)
        let position2 = ReceiptPosition(amount: 1, buyer: .notMe, owner: .notMe)
        XCTAssertNotEqual(position1, position2)
    }

    func testEquals_twoPositionswithDifferentOwner_returnsFalse() {
        let position1 = ReceiptPosition(amount: 1, buyer: .me, owner: .me)
        let position2 = ReceiptPosition(amount: 1, buyer: .me, owner: .notMe)
        XCTAssertNotEqual(position1, position2)
    }
}
