@testable import BillsDivider_Model
import XCTest

class PeopleTests: XCTestCase {
    func testEmpty_initializesPeopleWithZeroElements() {
        let people: People = .empty
        XCTAssertEqual(people.asArray, [])
    }

    func testFromArray_emptyArray_initializesPeopleWithZeroElements() {
        let people: People = .fromArray([])
        XCTAssertEqual(people.asArray, [])
    }

    func testFromArray_singleElement_initializesPeopleWithOneGivenElement() {
        let array: [Person] = [.withName("My name")]
        let people: People = .fromArray(array)
        XCTAssertEqual(people.asArray, array)
    }

    func testFromArray_twoElements_initializesPeopleWithTwoGivenElements() {
        let array: [Person] = [.withGeneratedName(forNumber: 1), .withGeneratedName(forNumber: 2)]
        let people: People = .fromArray(array)
        XCTAssertEqual(people.asArray, array)
    }

    func testFromPerson_initializesPeopleWithOneGivenElement() {
        let person: Person = .withName("My name")
        let people: People = .fromPerson(person)
        XCTAssertEqual(people.asArray, [person])
    }

    func testAny_noPeople_returnsFalse() {
        XCTAssertFalse(People.empty.any)
    }

    func testAny_onePerson_returnsTrue() {
        XCTAssertTrue(People.fromPerson(.withName("My name")).any)
    }

    func testFirst_noPeople_returnsNil() {
        XCTAssertNil(People.empty.first)
    }

    func testAppending_returnsPeopleWithAppendedItems() {
        var people: People = .empty

        let person1: Person = .withGeneratedName(forNumber: 1)
        people = people.appending(person1)

        let person2: Person = .withGeneratedName(forNumber: 2)
        people = people.appending(person2)

        let person3: Person = .withGeneratedName(forNumber: 3)
        people = people.appending(person3)

        XCTAssertEqual(people.asArray, [person1, person2, person3])
    }

    func testFirstIndexOfPerson_noPeople_returnsNil() {
        XCTAssertNil(People.empty.firstIndex(of: .withName("My name")))
    }

    func testFirstIndexOfPerson_twoPeopleAndAskingForNonExisting_returnsNil() {
        let person1: Person = .withGeneratedName(forNumber: 1)
        let person2: Person = .withGeneratedName(forNumber: 2)
        let people: People = .fromArray([person1, person2])
        XCTAssertNil(people.firstIndex(of: .withName("My name")))
    }

    func testFirstIndexOfPerson_twoPeopleAndAskingForExisting_returnsPersonsIndex() {
        let person1: Person = .withGeneratedName(forNumber: 1)
        let person2: Person = .withGeneratedName(forNumber: 2)
        let people: People = .fromArray([person1, person2])
        XCTAssertEqual(people.firstIndex(of: person2), 1)
    }

    func testFirst_twoPeople_returnsFirst() {
        let person1: Person = .withGeneratedName(forNumber: 1)
        let person2: Person = .withGeneratedName(forNumber: 2)
        XCTAssertEqual(People.fromArray([person1, person2]).first, person1)
    }

    func testEquals_twoTheSamePeopleInstances_returnsTrue() {
        let people: People = .fromPerson(.withName("My name"))
        XCTAssertTrue(people == people)
    }

    func testEquals_twoEmptyPeopleInstances_returnsTrue() {
        let people1: People = .empty
        let people2: People = .empty
        XCTAssertTrue(people1 == people2)
    }

    func testEquals_twoPeopleInstancesWithTheSamePerson_returnsTrue() {
        let person: Person = .withName("My name")
        let people1: People = .fromPerson(person)
        let people2: People = .fromPerson(person)
        XCTAssertTrue(people1 == people2)
    }

    func testEquals_oneEmptyPeopleInstanceAndOneWithPerson_returnsFalse() {
        let people1: People = .fromPerson(.withName("My name"))
        let people2: People = .empty
        XCTAssertFalse(people1 == people2)
        XCTAssertFalse(people2 == people1)
    }

    func testEquals_twoPeopleInstancesWithDifferentPersons_returnsFalse() {
        let people1: People = .fromPerson(.withGeneratedName(forNumber: 1))
        let people2: People = .fromPerson(.withGeneratedName(forNumber: 2))
        XCTAssertFalse(people1 == people2)
        XCTAssertFalse(people2 == people1)
    }
}
