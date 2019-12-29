@testable import BillsDivider
import XCTest

class OwnerTests: XCTestCase {
    func testFormatted_personCase_returnsGivenPersonName() {
        XCTAssertEqual(Owner.person(.init(name: "My name")).formatted, "My name")
    }

    func testAsPerson_allCase_returnsNil() {
        XCTAssertNil(Owner.all.asPerson)
    }

    func testAsPerson_personCase_returnsGivenPerson() {
        let person: Person = .withName("My name")
        XCTAssertEqual(Owner.person(person).asPerson, person)
    }

    func testEquals_twoAllCases_returnsTrue() {
        XCTAssertEqual(Owner.all, Owner.all)
    }

    func testEquals_allAndPersonCases_returnsFalse() {
        XCTAssertEqual(Owner.all, Owner.person(.empty))
        XCTAssertEqual(Owner.person(.empty), Owner.all)
    }

    func testEquals_twoTheSamePersonCases_returnsTrue() {
        let person: Person = .withGeneratedName(forNumber: 1)
        XCTAssertEqual(person, person)
    }

    func testEquals_twoDifferentPersonCases_returnsFalse() {
        let person1: Person = .withGeneratedName(forNumber: 1)
        let person2: Person = .withGeneratedName(forNumber: 2)
        XCTAssertNotEqual(person1, person2)
    }
}
