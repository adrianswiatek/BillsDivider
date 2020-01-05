@testable import BillsDivider
import XCTest

class OwnerTests: XCTestCase {
    func testAsPerson_allCase_returnsNil() {
        XCTAssertNil(Owner.all.asPerson)
    }

    func testAsPerson_personCase_returnsGivenPerson() {
        let person: Person = .withName("My name")
        XCTAssertEqual(Owner.person(person).asPerson, person)
    }

    func testFormatted_personCase_returnsGivenPersonName() {
        XCTAssertEqual(Owner.person(.withName("My name")).formatted, "My name")
    }

    func testFormatted_allCase_returnsAll() {
        XCTAssertEqual(Owner.all.formatted, "All")
    }

    func testEquals_twoAllCases_returnsTrue() {
        XCTAssertEqual(Owner.all, Owner.all)
    }

    func testEquals_allAndPersonCases_returnsFalse() {
        XCTAssertFalse(Owner.all == Owner.person(.empty))
        XCTAssertFalse(Owner.person(.empty) == Owner.all)
    }

    func testEquals_twoTheSamePersonCases_returnsTrue() {
        let person: Person = .withGeneratedName(forNumber: 1)
        XCTAssertTrue(Owner.person(person) == Owner.person(person))
    }

    func testEquals_twoDifferentPersonCases_returnsFalse() {
        let person1: Person = .withGeneratedName(forNumber: 1)
        let person2: Person = .withGeneratedName(forNumber: 2)
        XCTAssertFalse(Owner.person(person1) == Owner.person(person2))
    }

    func testHash_personCase_returnsHashOfPersons() {
        let person: Person = .withName("My name")
        XCTAssertEqual(Owner.person(person).hashValue, person.hashValue)
    }

    func testHash_allCase_returnsHashOfStringAll() {
        XCTAssertEqual(Owner.all.hashValue, "All".hashValue)
    }
}
