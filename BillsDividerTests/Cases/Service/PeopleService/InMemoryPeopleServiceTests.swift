@testable import BillsDivider
import Combine
import XCTest

class InMemoryPeopleServiceTests: XCTestCase {
    private var sut: PeopleService!
    private var subscriptions: [AnyCancellable]!

    override func setUp() {
        super.setUp()
        sut = InMemoryPeopleService(maximumNumberOfPeople: 2)
        subscriptions = []
    }

    override func tearDown() {
        sut = nil
        subscriptions = nil
        super.tearDown()
    }

    private func whenPeopleAdded(_ numberOfPeople: Int) {
        sut.updatePeople((0 ..< numberOfPeople).map { .withGeneratedName(forNumber: $0 + 1) })
    }

    func testInit_createsEmptyArrayOfPeople() {
        XCTAssertEqual(sut.numberOfPeople(), 0)
    }

    func testNumberOfPeople_whenNoPeopleAdded_returnsZero() {
        XCTAssertEqual(sut.numberOfPeople(), 0)
    }

    func testNumberOfPeople_returnsNumberOfPeople() {
        whenPeopleAdded(5)
        XCTAssertEqual(sut.numberOfPeople(), 5)
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

    func testUpdatePeople_sendsOutputThroughPeopleDidUpdate() {
        let people: [Person] = [.withGeneratedName(forNumber: 1), .withGeneratedName(forNumber: 2)]
        let expectation = self.expectation(description: "People are updated")
        var result: [Person] = []

        sut.peopleDidUpdate
            .dropFirst()
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        sut.updatePeople(people)

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], people[0])
        XCTAssertEqual(result[1], people[1])
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
