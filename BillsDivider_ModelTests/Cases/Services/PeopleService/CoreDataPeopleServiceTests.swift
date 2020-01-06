@testable import BillsDivider_Model
import Combine
import CoreData
import XCTest

class CoreDataPeopleServiceTests: XCTestCase {
    private var sut: PeopleService!
    private var context: NSManagedObjectContext!
    private var subscriptions: [AnyCancellable]!

    override func setUp() {
        super.setUp()
        context = InMemoryCoreDataStack().context
        sut = CoreDataPeopleService(context: context, maximumNumberOfPeople: 2)
        subscriptions = []
    }

    override func tearDown() {
        sut = nil
        context = nil
        subscriptions = nil
        super.tearDown()
    }

    func testInit_setsMaximumNumberOfPeople() {
        XCTAssertEqual(sut.maximumNumberOfPeople, 2)
    }

    func testInit_setsMinimumNumberOfPeople() {
        XCTAssertEqual(sut.minimumNumberOfPeople, 2)
    }

    func testUpdatePeople_withPeopleArray_saveIsCalled() {
        let people: People = .fromPerson(.withGeneratedName(forNumber: 1))
        let expectation = XCTNSNotificationExpectation(name: .NSManagedObjectContextDidSave)

        sut.updatePeople(people)

        wait(for: [expectation], timeout: 0.3)
    }

    func testUpdatePeople_withPeopleArray_sendsArrayWithGivenPeopleThroughPeopleDidUpdate() {
        let people: People = .fromArray([
            .withGeneratedName(forNumber: 1),
            .withGeneratedName(forNumber: 2)
        ])
        var result: People = .empty
        let expectation = self.expectation(description: "People are sent")
        sut.peopleDidUpdate
            .dropFirst()
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        sut.updatePeople(people)

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], people[0])
        XCTAssertEqual(result[1], people[1])
    }

    func testUpdatePeople_withEmptyPeopleArray_saveIsNotCalled() {
        let expectation = XCTNSNotificationExpectation(name: .NSManagedObjectContextDidSave)
        expectation.isInverted = true

        sut.updatePeople(.empty)

        wait(for: [expectation], timeout: 0.3)
    }

    func testUpdatePeople_withEmptyPeopleArray_sendsEmptyArrayThroughPeopleDidUpdate() {
        var result: People?
        let expectation = self.expectation(description: "People are sent")
        sut.peopleDidUpdate
            .dropFirst()
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        sut.updatePeople(.empty)

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(result, .empty)
    }

    func testUpdatePeople_whenNoPeoplePersisted_persistsPeopleInGivenOrder() {
        let people: People = .fromArray([
            .withGeneratedName(forNumber: 1),
            .withGeneratedName(forNumber: 2),
            .withGeneratedName(forNumber: 3),
            .withGeneratedName(forNumber: 4)
        ])
        sut.updatePeople(people)

        let persistedPeople = sut.fetchPeople()
        XCTAssertEqual(persistedPeople, people)
    }

    func testUpdatePeople_whenUpdateExistingPerson_persistsUpdatedPerson() {
        let originalPerson: Person = .withName("Original name")
        sut.updatePeople(.fromPerson(originalPerson))

        let updatedPerson: Person = originalPerson.withUpdated(name: "Updated name")
        sut.updatePeople(.fromPerson(updatedPerson))

        let result = sut.fetchPeople()

        XCTAssertEqual(result[0], updatedPerson)
    }

    func testPeopleDidUpdate_whenNoPeoplePersisted_sendsEmptyArrayWhenSubscribed() {
        var result: People?
        let expectation = self.expectation(description: "People are sent")
        sut.peopleDidUpdate
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(result, .empty)
    }

    func testFetchPeople_whenNoPeoplePersisted_returnsEmptyArray() {
        XCTAssertEqual(sut.fetchPeople(), .empty)
    }

    func testFetchPeople_whenOnePersonPersisted_returnsArrayWithOnePerson() {
        let people: People = .fromPerson(.withName("My name"))
        sut.updatePeople(people)

        let result = sut.fetchPeople()

        XCTAssertEqual(result, people)
    }

    func testFetchPeople_whenTwoPeoplePersisted_returnsArrayWithTwoPeople() {
        let people: People = .fromArray([
            .withGeneratedName(forNumber: 1),
            .withGeneratedName(forNumber: 2)
        ])
        sut.updatePeople(people)

        let result = sut.fetchPeople()

        XCTAssertEqual(result, people)
    }

    func testNumberOfPeople_whenNoPeoplePersisted_returnsZero() {
        XCTAssertEqual(sut.numberOfPeople(), 0)
    }

    func testNumberOfPeople_whenOnePersonPersisted_returnsOne() {
        sut.updatePeople(.fromPerson(.withName("My name")))
        XCTAssertEqual(sut.numberOfPeople(), 1)
    }

    func testNumberOfPeople_whenTwoPeoplePersisted_returnsTwo() {
        let people: People = .fromArray([
            .withGeneratedName(forNumber: 1),
            .withGeneratedName(forNumber: 2)
        ])
        sut.updatePeople(people)
        XCTAssertEqual(sut.numberOfPeople(), 2)
    }
}
