@testable import BillsDivider
import XCTest

class InMemoryPeopleServiceTests: XCTestCase {
    private var sut: PeopleService!

    override func setUp() {
        super.setUp()
        sut = InMemoryPeopleService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func whenPeopleAdded(_ numberOfPeople: Int) {
        (0 ..< numberOfPeople).forEach {
            sut.addPerson(.withGeneratedName(forNumber: $0 + 1))
        }
    }

    func testInit_createsEmptyArrayOfPeople() {
        XCTAssertEqual(sut.getNumberOfPeople(), 0)
    }

    func testFetchPeople_returnsEmptyArrayOfPeople() {
        XCTAssertEqual(sut.fetchPeople(), [])
    }

    func testAddPerson_addsGivenPerson() {
        let person: Person = .withName("My name")
        sut.addPerson(person)
        XCTAssertEqual(person, sut.fetchPeople().first)
    }

    func testRemovePerson_removesGivenPerson() {
        let person: Person = .withName("My name")
        sut.addPerson(person)
        sut.removePerson(person)
        XCTAssertEqual(sut.getNumberOfPeople(), 0)
    }

    func testRemovePerson_withNonExistingPerson_doesNothing() {
        let person: Person = .withName("My name")
        sut.removePerson(person)
        XCTAssertEqual(sut.getNumberOfPeople(), 0)
    }

    func testUpdatePerson_updatesGivenPerson() {
        let originalPerson: Person = .withName("Original person")
        sut.addPerson(originalPerson)

        let updatedPerson = originalPerson.withUpdated(name: "Updated person")
        sut.updatePerson(updatedPerson)

        XCTAssertEqual(sut.fetchPeople().first?.name, "Updated person")
    }

    func testCanRemovePerson_whenTwoPeopleInTheList_returnsFalse() {
        whenPeopleAdded(2)
        XCTAssertFalse(sut.canRemovePerson())
    }

    func testCanRemovePerson_whenThreePeopleInTheList_returnsTrue() {
        whenPeopleAdded(3)
        XCTAssertTrue(sut.canRemovePerson())
    }
}
