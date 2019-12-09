@testable import BillsDivider
import XCTest

class OwnerTests: XCTestCase {
    func testFormatted_meCase_returnsMe() {
        XCTAssertEqual(Owner.me.formatted, "Me")
    }

    func testFormatted_notMeCase_returnsThey() {
        XCTAssertEqual(Owner.notMe.formatted, "They")
    }

    func testFormatted_allCase_returnsAll() {
        XCTAssertEqual(Owner.all.formatted, "All")
    }

    func testFromString_meString_returnsMeCase() {
        XCTAssertEqual(Owner.from(string: "me"), .me)
    }

    func testFromString_notMeString_returnsNotMeCase() {
        XCTAssertEqual(Owner.from(string: "notMe"), .notMe)
    }

    func testFromString_allString_returnsAllCase() {
        XCTAssertEqual(Owner.from(string: "all"), .all)
    }

    func testFromString_randomString_returnsNil() {
        XCTAssertNil(Owner.from(string: "random string"))
    }
}
