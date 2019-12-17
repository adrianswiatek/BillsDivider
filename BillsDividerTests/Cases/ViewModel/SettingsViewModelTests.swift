@testable import BillsDivider
import Combine
import XCTest

class SettingsViewModelTests: XCTestCase {
    private var sut: SettingsViewModel!

    override func setUp() {
        super.setUp()
        sut = SettingsViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testInit_setsPeopleCountToTwo() {
        XCTAssertEqual(sut.people.count, 2)
    }

    func testInit_setsFirstPersonToMe() {
        XCTAssertEqual(sut.people[0], "1st person")
    }

    func testInit_setsSecondPersonTo2ndPerson() {
        XCTAssertEqual(sut.people[1], "2nd person")
    }

    func testInit_setsPeopleRangeBetween2And3() {
        XCTAssertEqual(sut.peopleRange, 2...3)
    }

    func testAddPerson_adds3rdPersonAtTheVeryEndOfPeopleProperty() {
        sut.addPerson()
        XCTAssertEqual(sut.people.last, "3rd person")
    }

    func testAddPerson_withTwoPeople_adds4thPersonAtTheVeryEndOfPeopleProperty() {
        sut.addPerson()
        sut.addPerson()

        XCTAssertEqual(sut.people[3], "4th person")
    }

    func testRemovePerson_withDefaultPeople_doesNotChangePeopleProperty() {
        sut.removePerson()
        XCTAssertEqual(sut.people.count, 2)
    }

    func testRemovePerson_withOnePersonAdded_removesThatPerson() {
        sut.addPerson()
        let lastPerson = sut.people.last!

        sut.removePerson()

        XCTAssertFalse(sut.people.contains(lastPerson))
    }

    func testRemovePerson_withTwoPeopleAdded_removesTheSecondOnePerson() {
        sut.addPerson()
        sut.addPerson()
        let lastPerson = sut.people.last!

        sut.removePerson()

        XCTAssertFalse(sut.people.contains(lastPerson))
    }

    func testNumberOfPeople_get_returnsNumberOfPeople() {
        XCTAssertEqual(sut.numberOfPeople, 2)

        sut.addPerson()
        sut.addPerson()

        XCTAssertEqual(sut.numberOfPeople, 4)
    }

    func testNumberOfPeople_setOneNumberGreaterThanActual_addsPersonToPeopleProperty() {
        sut.numberOfPeople = 3
        XCTAssertEqual(sut.people.count, 3)
    }

    func testNumberOfPeople_setTwoNumberGreaterThanActual_addsTwoPeopleToPeopleProperty() {
        sut.numberOfPeople = 4
        XCTAssertEqual(sut.people.count, 4)
    }

    func testNumberOfPeople_setOneNumberLowerThanActual_removesPersonFromPeopleProperty() {
        sut.numberOfPeople = 3
        XCTAssertEqual(sut.people.count, 3)

        sut.numberOfPeople = 2
        XCTAssertEqual(sut.people.count, 2)
    }

    func testNumberOfPeople_setNumberOne_doesNothingWithPoepleProperty() {
        sut.numberOfPeople = 1
        XCTAssertEqual(sut.people.count, 2)
    }
}
