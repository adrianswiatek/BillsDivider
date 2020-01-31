@testable import BillsDivider_Model
@testable import BillsDivider_ViewModel
import Combine
import XCTest

class SettingsViewModelTests: XCTestCase {
    private var sut: SettingsViewModel!
    private var peopleService: PeopleServiceFake!
    private var subscriptions: [AnyCancellable]!

    override func setUp() {
        super.setUp()
        peopleService = PeopleServiceFake()
        sut = SettingsViewModel(peopleService, [])
        subscriptions = []
    }

    override func tearDown() {
        peopleService = nil
        sut = nil
        super.tearDown()
    }

    func whenPeopleAdded(_ numberOfPeople: Int) {
        (0 ..< numberOfPeople).forEach { _ in sut.addPerson() }
    }

//    func testAddPerson_adds3rdPersonAtTheVeryEndOfPeopleProperty() {
//        whenPeopleAdded(2)
//
//        sut.addPerson()
//
//        XCTAssertEqual(sut.people[2].name, "3rd person")
//    }

//    func testAddPerson_withTwoPeople_adds4thPersonAtTheVeryEndOfPeopleProperty() {
//        whenPeopleAdded(2)
//
//        sut.addPerson()
//        sut.addPerson()
//
//        XCTAssertEqual(sut.people[3].name, "4th person")
//    }

    func testAddPerson_addsEmptyPersonNameToPeopleNamesArray() {
        whenPeopleAdded(1)
        XCTAssertEqual(sut.peopleNames[0], "1st person")
    }

    func testAddPerson_withTwoPeople_addsTwoEmptyPersonNamesToPeopleNamesArray() {
        whenPeopleAdded(2)
        XCTAssertEqual(sut.peopleNames.count, 2)
    }

    func testCanAddPerson_callsCanAddPersonOnPeopleService() {
        _ = sut.canAddPerson()
        XCTAssertTrue(peopleService.canAddPersonHasBeenCalled)
    }

    func testCanRemovePerson_callsCanRemovePersonOnPeopleService() {
        _ = sut.canRemovePerson()
        XCTAssertTrue(peopleService.canRemovePersonHasBeenCalled)
    }

//    func testPlaceholderForPerson_whenNameIsSet_returnsEmptyString() {
//        let person: Person = .withName("My name")
//        XCTAssertEqual(sut.placeholder(for: person), "")
//    }

//    func testPlaceholderForPerson_whenNameIsGenerated_returnsProperName() {
//        let person: Person = .withGeneratedName(forNumber: 1)
//        XCTAssertEqual(sut.placeholder(for: person), "1st person")
//    }

//    func testNameForPerson_whenNameIsSet_returnsProperName() {
//        let person: Person = .withName("My name")
//        XCTAssertEqual(sut.name(for: person), "My name")
//    }

//    func testNameForPerson_whenNameIsGenerated_returnsEmptyString() {
//        let person: Person = .withGeneratedName(forNumber: 1)
//        XCTAssertEqual(sut.name(for: person), "")
//    }

//    func testIndexOfPerson_returnsIndexOfPerson() {
//        whenPeopleAdded(5)
//        let thirdPerson = sut.people[2]
//        XCTAssertEqual(sut.index(of: thirdPerson), 2)
//    }

//    func testPeopleNames_whenUpdate_callsUpdatePeopleOnPeopleService() {
//        whenPeopleAdded(1)
//        let expectation = self.expectation(description: "update person")
//        sut.$people
//            .dropFirst(1)
//            .sink { _ in expectation.fulfill() }
//            .store(in: &subscriptions)
//
//        sut.peopleNames[0] = "My name"
//
//        wait(for: [expectation], timeout: 2)
//        XCTAssertTrue(peopleService.updatePeopleHasBeenCalled)
//    }
}
