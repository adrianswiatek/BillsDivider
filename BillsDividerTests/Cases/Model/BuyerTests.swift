@testable import BillsDivider
import XCTest

class BuyerTests: XCTestCase {
    func testFormatted_meCase_returnsMe() {
        XCTAssertEqual(Buyer.me.formatted, "Me")
    }

    func testFormatted_notMeCase_returnsNotMe() {
        XCTAssertEqual(Buyer.notMe.formatted, "They")
    }

    // MARK: - isEqualTo(owner:)
    func testIsEqualTo_buyerSetToMeAndOwnerSetToMe_returnsTrue() {
        XCTAssertTrue(Buyer.me.isEqualTo(owner: .me))
    }

    func testIsEqualTo_buyerSetToMeAndOwnerSetToNotMe_returnsFalse() {
        XCTAssertFalse(Buyer.me.isEqualTo(owner: .notMe))
    }

    func testIsEqualTo_buyerSetToMeAndOwnerSetToAll_returnsFalse() {
        XCTAssertFalse(Buyer.me.isEqualTo(owner: .all))
    }

    func testIsEqualTo_buyerSetToNotMeAndOwnerSetToMe_returnsFalse() {
        XCTAssertFalse(Buyer.notMe.isEqualTo(owner: .me))
    }

    func testIsEqualTo_buyerSetToNotMeAndOwnerSetToNotMe_returnsTrue() {
        XCTAssertTrue(Buyer.notMe.isEqualTo(owner: .notMe))
    }

    func testIsEqualTo_buyerSetToNotMeAndOwnerSetToAll_returnsFalse() {
        XCTAssertFalse(Buyer.notMe.isEqualTo(owner: .all))
    }

    // MARK: - isNotEqualTo(owner:)
    func testIsNotEqualTo_buyerSetToMeAndOwnerSetToMe_returnsFalse() {
        XCTAssertFalse(Buyer.me.isNotEqualTo(owner: .me))
    }

    func testIsNotEqualTo_buyerSetToMeAndOwnerSetToNotMe_returnsTrue() {
        XCTAssertTrue(Buyer.me.isNotEqualTo(owner: .notMe))
    }

    func testIsNotEqualTo_buyerSetToMeAndOwnerSetToAll_returnsTrue() {
        XCTAssertTrue(Buyer.me.isNotEqualTo(owner: .all))
    }

    func testIsNotEqualTo_buyerSetToNotMeAndOwnerSetToMe_returnsTrue() {
        XCTAssertTrue(Buyer.notMe.isNotEqualTo(owner: .me))
    }

    func testIsNotEqualTo_buyerSetToNotMeAndOwnerSetToNotMe_returnsFalse() {
        XCTAssertFalse(Buyer.notMe.isNotEqualTo(owner: .notMe))
    }

    func testIsNotEqualTo_buyerSetToNotMeAndOwnerSetToAll_returnsTrue() {
        XCTAssertTrue(Buyer.notMe.isNotEqualTo(owner: .all))
    }

    // MARK: - next()
    func testNext_meCase_returnsNotMe() {
        XCTAssertEqual(Buyer.me.next(), .notMe)
    }

    func testNext_notMeCase_returnsMe() {
        XCTAssertEqual(Buyer.notMe.next(), .me)
    }
}
