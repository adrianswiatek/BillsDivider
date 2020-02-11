@testable import BillsDivider_Model
@testable import BillsDivider_ViewModel
import Combine
import XCTest

class PersonViewModelTests: XCTestCase {
    private var sut: PersonViewModel!
    private var person: Person!
    private var subscriptions: [AnyCancellable]!

    override func setUp() {
        super.setUp()
        subscriptions = []
        person = .withName("My name")
        sut = PersonViewModel(person: person, withIndex: 0)
    }

    override func tearDown() {
        sut = nil
        person = nil
        subscriptions = nil
        super.tearDown()
    }

    func testInit_setsPersonsName() {
        XCTAssertEqual(sut.name, "My name")
    }

    func testInit_setsPersonsColor() {
        XCTAssertEqual(sut.color, PersonColors.default.background.asColor)
    }

    func testInit_setsHasDetailsOpenedToFalse() {
        XCTAssertFalse(sut.hasDetailsOpened)
    }

    func testEquals_twoObjectsWithTheSamePerson_returnsTrue() {
        let person: Person = .withName("My name")
        let firstViewModel: PersonViewModel = .init(person: person, withIndex: 0)
        let secondViewModel: PersonViewModel = .init(person: person, withIndex: 0)

        XCTAssertTrue(firstViewModel == secondViewModel)
    }

    func testEquals_twoObjectsWithDifferentPersons_returnFalse() {
        let firstPerson: Person = .withGeneratedName(forNumber: 1)
        let firstViewModel: PersonViewModel = .init(person: firstPerson, withIndex: 0)

        let secondPerson: Person = .withGeneratedName(forNumber: 2)
        let secondViewModel: PersonViewModel = .init(person: secondPerson, withIndex: 0)

        XCTAssertFalse(firstViewModel == secondViewModel)
    }

    func testPlaceHolder_personWithGeneratedName_returnsGeneratedName() {
        let person: Person = .withGeneratedName(forNumber: 1)
        let sut: PersonViewModel = .init(person: person, withIndex: 0)
        XCTAssertEqual(sut.placeHolder, person.name)
    }

    func testPlaceHolder_personWithCustomName_returnsEmptyString() {
        let person: Person = .withName("My name")
        let sut: PersonViewModel = .init(person: person, withIndex: 0)
        XCTAssertEqual(sut.placeHolder, "")
    }

    func testOnNameChanged_firedUpPersonHasChanged() {
        let expectation = self.expectation(description: "Person has changed")
        sut.personHasChanged
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &subscriptions)

        sut.name = "New name"

        wait(for: [expectation], timeout: 0.5)
    }

    func testName_change_firedUpPersonHasChangedWithNewPerson() {
        var newPerson: Person?

        let expectation = self.expectation(description: "Person has changed")
        sut.personHasChanged
            .dropFirst()
            .sink {
                newPerson = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        sut.name = "New name"

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(newPerson?.name, "New name")
    }

    func testColor_change_firedUpPersonHasChanged() {
        let expectation = self.expectation(description: "Person has changed")
        sut.personHasChanged
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &subscriptions)

        sut.color = .purple

        wait(for: [expectation], timeout: 0.3)
    }

    func testColor_change_firedUpPersonHasChangedWithNewPerson() {
        var newPerson: Person?

        let expectation = self.expectation(description: "Person has changed")
        sut.personHasChanged
            .dropFirst()
            .sink {
                newPerson = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        sut.color = .purple

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(newPerson?.colors.background.asColor, .purple)
    }
}
