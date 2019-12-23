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
        sut.updatePeople((0 ..< numberOfPeople).map { .withGeneratedName(forNumber: $0 + 1) })
    }

    func testInit_createsEmptyArrayOfPeople() {
        XCTAssertEqual(sut.getNumberOfPeople(), 0)
    }

    func testFetchPeople_returnsEmptyArrayOfPeople() {
        XCTAssertEqual(sut.fetchPeople(), [])
    }

    func testUpdatePeople_whenInitiallyEmptyArrayAndNewPeopleAdding_addsGivenPeople() {
        let person1: Person = .withGeneratedName(forNumber: 1)
        let person2: Person = .withGeneratedName(forNumber: 2)

        sut.updatePeople([person1, person2])

        let people = sut.fetchPeople()
        XCTAssertEqual(people.count, 2)
        XCTAssertEqual(people[0], person1)
        XCTAssertEqual(people[1], person2)
    }

    func testUpdatePeople_whenInitiallyFilledArrayAndAllPeopleRemoving_removesAllPeople() {
        whenPeopleAdded(3)
        sut.updatePeople([])
        XCTAssertEqual(sut.fetchPeople().count, 0)
    }

    func testUpdatePeople_whenInitiallyFilledArrayAndPersonUpdating_updatesGivenPerson() {
        whenPeopleAdded(3)
        let people = sut.fetchPeople()
        let updatedPerson = people[1].withUpdated(name: "My name")

        sut.updatePeople([people[0]] + [updatedPerson] + [people[2]])

        XCTAssertEqual(sut.fetchPeople()[1].name, "My name")
    }

    func testCanAddPerson_whenNumberOfPeopleIsLowerThanMaximum_returnsTrue() {
        sut = InMemoryPeopleService(maximumNumberOfPeople: 3)
        whenPeopleAdded(2)
        XCTAssertTrue(sut.canAddPerson())
    }

    func testCanAddPerson_whenNumberOfPeopleIsGreaterThanMaximum_returnsFalse() {
        sut = InMemoryPeopleService(maximumNumberOfPeople: 2)
        whenPeopleAdded(3)
        XCTAssertFalse(sut.canAddPerson())
    }

    func testCanAddPerson_whenNumberOfPeopleIsEqualToMaximum_returnsFalse() {
        sut = InMemoryPeopleService(maximumNumberOfPeople: 2)
        whenPeopleAdded(2)
        XCTAssertFalse(sut.canAddPerson())
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
