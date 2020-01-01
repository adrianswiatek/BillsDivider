@testable import BillsDivider
import XCTest

class BuyerTests: XCTestCase {
    func testFormatted_personCase_returnsGivenPersonName() {
        XCTAssertEqual(Buyer.person(.withName("My name")).formatted, "My name")
    }

    func testAsPerson_personCase_returnsGivenPerson() {
        let person: Person = .withName("My name")
        XCTAssertEqual(Buyer.person(person).asPerson, person)
    }

    func testIsEqualTo_BuyerSetToPersonAndOwnerSetToAll_returnsFalse() {
        XCTAssertFalse(Buyer.person(.withName("My name")).isEqualTo(.all))
    }

    func testIsEqualTo_BuyerAndOwnerSetToTheSamePerson_returnsTrue() {
        let person: Person = .withName("My name")
        XCTAssertTrue(Buyer.person(person).isEqualTo(.person(person)))
    }

    func testIsEqualTo_BuyerAndOwnerSetToDifferentPersons_returnsFalse() {
        let person1: Person = .withGeneratedName(forNumber: 1)
        let person2: Person = .withGeneratedName(forNumber: 2)
        XCTAssertFalse(Buyer.person(person1).isEqualTo(.person(person2)))
    }

    func testIsNotEqual_BuyerSetToPersonAndOwnerSetToAll_returnsTrue() {
        XCTAssertTrue(Buyer.person(.withName("My name")).isNotEqualTo(.all))
    }

    func testIsNotEqual_BuyerAndOwnerSetToTheSamePerson_returnsFalse() {
        let person: Person = .withName("My name")
        XCTAssertFalse(Buyer.person(person).isNotEqualTo(.person(person)))
    }

    func testIsNotEqual_BuyerAndOwnerSetToDifferentPersons_returnsTrue() {
        let person1: Person = .withGeneratedName(forNumber: 1)
        let person2: Person = .withGeneratedName(forNumber: 2)
        XCTAssertTrue(Buyer.person(person1).isNotEqualTo(.person(person2)))
    }

    func testEquals_twoTheSamePersons_returnsTrue() {
        let person: Person = .withGeneratedName(forNumber: 1)
        XCTAssertTrue(Buyer.person(person) == Buyer.person(person))
    }

    func testEquals_twoDifferentPersons_returnsFalse() {
        let person1: Person = .withGeneratedName(forNumber: 1)
        let person2: Person = .withGeneratedName(forNumber: 2)
        XCTAssertFalse(Buyer.person(person1) == Buyer.person(person2))
    }
}
