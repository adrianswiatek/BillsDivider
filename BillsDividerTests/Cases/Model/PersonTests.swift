@testable import BillsDivider
import XCTest

class PersonTests: XCTestCase {
    func testEmpty_returnsPersonInEmptyState() {
        XCTAssertEqual(Person.empty.state, .empty)
    }

    func testEmpty_returnsPersonWithEmptyName() {
        XCTAssertEqual(Person.empty.name, "")
    }

    func testEmpty_returnsPersonWithEmptyId() {
        XCTAssertEqual(Person.empty.id.uuidString, "00000000-0000-0000-0000-000000000000")
    }

    func testWithGeneratedNumber_returnsPersonInGeneratedState() {
        let person: Person = .withGeneratedName(forNumber: 1)
        XCTAssertEqual(person.state, .generated)
    }

    func testWithGeneratedNameForNumber1_returnsPersonWithProperName() {
        let person: Person = .withGeneratedName(forNumber: 1)
        XCTAssertEqual(person.name, "1st person")
    }

    func testWithGeneratedNameForNumber2_returnsPersonWithProperName() {
        let person: Person = .withGeneratedName(forNumber: 2)
        XCTAssertEqual(person.name, "2nd person")
    }

    func testWithGeneratedNameForNumber3_returnsPersonWithProperName() {
        let person: Person = .withGeneratedName(forNumber: 3)
        XCTAssertEqual(person.name, "3rd person")
    }

    func testWithName_returnsPersonInDefaultState() {
        let person: Person = .withName("My name")
        XCTAssertEqual(person.state, .default)
    }

    func testWithName_returnsPersonWithGeneratedUuid() {
        let person: Person = .withName("My name")
        XCTAssertNotEqual(person.id.uuidString, "00000000-0000-0000-0000-000000000000")
    }

    func testWithName_returnsPersonWithGivenName() {
        let person: Person = .withName("My name")
        XCTAssertEqual(person.name, "My name")
    }

    func testEquals_theSamePerson_returnsTrue() {
        let person: Person = .withName("My name")
        XCTAssertEqual(person, person)
    }

    func testEquals_differentPersons_returnsFalse() {
        let person1: Person = .withName("First person")
        let person2: Person = .withName("Second person")
        XCTAssertNotEqual(person1, person2)
    }

    func testWithUpdatedName_returnsPersonWithChangedName() {
        let originalPerson: Person = .withName("Original name")
        let updatedPerson: Person = originalPerson.withUpdated(name: "Updated name")
        XCTAssertEqual(updatedPerson.name, "Updated name")
    }

    func testWithUpdatedName_whenEmptyPerson_returnsPersonInDefaultState() {
        let originalPerson: Person = .empty
        let updatedPerson: Person = originalPerson.withUpdated(name: "Updated name")
        XCTAssertEqual(updatedPerson.state, .default)
    }

    func testWithUpdatedName_whenEmptyName_returnsPersonInEmptyState() {
        let originalPerson: Person = .withName("Original name")
        let updatedPerson: Person = originalPerson.withUpdated(name: "")
        XCTAssertEqual(updatedPerson.state, .empty)
    }

    func testWithUpdatedName_whenGeneratedPerson_returnsPersonInDefaultState() {
        let originalPerson: Person = .withGeneratedName(forNumber: 1)
        let updatedPerson: Person = originalPerson.withUpdated(name: "Updated name")
        XCTAssertEqual(updatedPerson.state, .default)
    }

    func testWithUpdatedNameAndNumber_whenEmptyNameAndNumberProvided_returnsPersonInGeneratedState() {
        let originalPerson: Person = .withName("Original name")
        let updatedPerson: Person = originalPerson.withUpdated(name: "", andNumber: 1)
        XCTAssertEqual(updatedPerson.state, .generated)
    }
}
