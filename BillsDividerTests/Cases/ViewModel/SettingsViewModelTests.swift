@testable import BillsDivider
import Combine
import XCTest

class SettingsViewModelTests: XCTestCase {
    private var sut: SettingsViewModel!
    private var peopleService: PeopleServiceMock!

    override func setUp() {
        super.setUp()
        peopleService = PeopleServiceMock()
        sut = SettingsViewModel(peopleService: peopleService, maximumNumberOfPeople: 3)
    }

    override func tearDown() {
        peopleService = nil
        sut = nil
        super.tearDown()
    }

    func whenTwoInitialPersonAdded() {
        sut.addPerson()
        sut.addPerson()
    }

    func testAddPerson_adds3rdPersonAtTheVeryEndOfPeopleProperty() {
        whenTwoInitialPersonAdded()

        sut.addPerson()
        
        XCTAssertEqual(sut.people[2].name, "3rd person")
    }

    func testAddPerson_withTwoPeople_adds4thPersonAtTheVeryEndOfPeopleProperty() {
        whenTwoInitialPersonAdded()

        sut.addPerson()
        sut.addPerson()

        XCTAssertEqual(sut.people[3].name, "4th person")
    }

    func testCanAddPerson_whenNumberOfPeopleIsLessThanMaximum_returnsTrue() {
        sut = SettingsViewModel(peopleService: peopleService, maximumNumberOfPeople: 3)
        XCTAssertTrue(sut.canAddPerson())
    }

    func testCanAddPerson_whenNumberOfPeopleIsEqualToMaximum_returnsFalse() {
        sut = SettingsViewModel(peopleService: peopleService, maximumNumberOfPeople: 2)
        whenTwoInitialPersonAdded()
        XCTAssertFalse(sut.canAddPerson())
    }

    func testAddPerson_callsAddPersonOnPeopleService() {
        sut.addPerson()
        XCTAssertTrue(peopleService.addPersonHasBeenCalled)
    }

    func testCanRemovePerson_callsCanRemovePersonOnPeopleService() {
        _ = sut.canRemovePerson()
        XCTAssertTrue(peopleService.canRemovePersonHasBeenCalled)
    }

    func testGetPlaceholderForPerson_whenNameIsSet_returnsEmptyString() {
        let person: Person = .withName("My name")
        XCTAssertEqual(sut.getPlaceholder(for: person), "")
    }

    func testGetPlaceholderForPerson_whenNameIsGenerated_returnsProperName() {
        let person: Person = .withGeneratedName(forNumber: 1)
        XCTAssertEqual(sut.getPlaceholder(for: person), "1st person")
    }

    func testGetNameForPerson_whenNameIsSet_returnsProperName() {
        let person: Person = .withName("My name")
        XCTAssertEqual(sut.getName(for: person), "My name")
    }

    func testGetNameForPerson_whenNameIsGenerated_returnsEmptyString() {
        let person: Person = .withGeneratedName(forNumber: 1)
        XCTAssertEqual(sut.getName(for: person), "")
    }
}
