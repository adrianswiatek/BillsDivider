@testable import BillsDivider
import Combine
import XCTest

class SettingsViewModelTests: XCTestCase {
    private var sut: SettingsViewModel!

    override func setUp() {
        super.setUp()
        sut = SettingsViewModel(minimumNumberOfPeople: 2, maximumNumberOfPeople: 3)
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

    func testAddPerson_adds3rdPersonAtTheVeryEndOfPeopleProperty() {
        sut.addPerson()
        XCTAssertEqual(sut.people.last, "3rd person")
    }

    func testAddPerson_withTwoPeople_adds4thPersonAtTheVeryEndOfPeopleProperty() {
        sut.addPerson()
        sut.addPerson()

        XCTAssertEqual(sut.people[3], "4th person")
    }

    func testCanAddPerson_whenNumberOfPeopleIsLessThanMaximum_returnsTrue() {
        sut = SettingsViewModel(minimumNumberOfPeople: 2, maximumNumberOfPeople: 3)
        XCTAssertTrue(sut.canAddPerson())
    }

    func testCanAddPerson_whenNumberOfPeopleIsEqualToMaximum_returnsFalse() {
        sut = SettingsViewModel(minimumNumberOfPeople: 2, maximumNumberOfPeople: 2)
        XCTAssertFalse(sut.canAddPerson())
    }

    func testCanRemovePerson_whenIndexIsGreaterThanMinimum_returnsTrue() {
        sut = SettingsViewModel(minimumNumberOfPeople: 2, maximumNumberOfPeople: 3)
        sut.addPerson()
        XCTAssertTrue(sut.canRemovePerson(atIndex: 2))
    }

    func testCanRemovePerson_whenIndexIsEqualToMinium_returnsFalse() {
        sut = SettingsViewModel(minimumNumberOfPeople: 2, maximumNumberOfPeople: 3)
        XCTAssertFalse(sut.canRemovePerson(atIndex: 1))
    }

    func testCanRemovePerson_whenIndexIsLessThanMinimum_returnsFalse() {
        sut = SettingsViewModel(minimumNumberOfPeople: 2, maximumNumberOfPeople: 3)
        XCTAssertFalse(sut.canRemovePerson(atIndex: 0))
    }
}
