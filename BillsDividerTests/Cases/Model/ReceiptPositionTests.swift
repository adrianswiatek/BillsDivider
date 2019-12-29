@testable import BillsDivider
import XCTest

class ReceiptPositionTests: XCTestCase {
    func testEmpty_returnsReceiptPositionWithZeroAmount() {
        XCTAssertEqual(ReceiptPosition.empty.amount, 0)
    }

    func testEmpty_returnsReceiptPositionWithBuyerAsEmptyPerson() {
        XCTAssertEqual(ReceiptPosition.empty.buyer, .person(.empty))
    }

    func testEmpty_returnsReceiptPositionWithOwnerSetToAll() {
        XCTAssertEqual(ReceiptPosition.empty.owner, .all)
    }

    func testEquals_twoTheSamePositions_returnsTrue() {
        let position: ReceiptPosition = .init(amount: 1, buyer: .person(.empty), owner: .all)
        XCTAssertTrue(position == position)
    }

    func testEquals_twoNewButTheSamePositions_returnsTrue() {
        let person = Person.withName("My name")
        let position1 = ReceiptPosition(amount: 1, buyer: .person(person), owner: .all)
        let position2 = ReceiptPosition(amount: 1, buyer: .person(person), owner: .all)
        XCTAssertTrue(position1 == position2)
    }

    func testEquals_twoPositionsWithDifferentAmount_returnsFalse() {
        let person = Person.withName("My name")
        let position1 = ReceiptPosition(amount: 1, buyer: .person(person), owner: .all)
        let position2 = ReceiptPosition(amount: 2, buyer: .person(person), owner: .all)
        XCTAssertFalse(position1 == position2)
    }

    func testEquals_twoPositionsWithDifferentBuyer_returnsFalse() {
        let position1 = ReceiptPosition(amount: 1, buyer: .person(.withGeneratedName(forNumber: 1)), owner: .all)
        let position2 = ReceiptPosition(amount: 1, buyer: .person(.withGeneratedName(forNumber: 2)), owner: .all)
        XCTAssertFalse(position1 == position2)
    }

    func testEquals_twoPositionsWithDifferentOwner_returnsFalse() {
        let person = Person.withName("My name")
        let position1 = ReceiptPosition(amount: 1, buyer: .person(person), owner: .person(person))
        let position2 = ReceiptPosition(amount: 1, buyer: .person(person), owner: .all)
        XCTAssertFalse(position1 == position2)
    }
}
