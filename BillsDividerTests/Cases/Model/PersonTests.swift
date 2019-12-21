@testable import BillsDivider
import XCTest

class PersonTests: XCTestCase {
    func testEquals_theSamePerson_returnsTrue() {
        let person = Person()
        XCTAssertEqual(person, person)
    }

    func testEquals_differentPersons_returnsFalse() {
        let person1 = Person(name: "First person")
        let person2 = Person(name: "Second person")
        XCTAssertNotEqual(person1, person2)
    }

    func testWithUpdatedName_returnsPersonWithChangedName() {
        let originalPerson = Person(name: "Original name")
        let updatedPerson = originalPerson.withUpdated(name: "Updated name")
        XCTAssertEqual(updatedPerson.name, "Updated name")
    }
}
