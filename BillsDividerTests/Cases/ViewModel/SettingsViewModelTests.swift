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
        XCTAssertEqual(sut.people[0], "Me")
    }

    func testInit_setsSecondPersonTo2ndPerson() {
        XCTAssertEqual(sut.people[1], "2nd person")
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
}
