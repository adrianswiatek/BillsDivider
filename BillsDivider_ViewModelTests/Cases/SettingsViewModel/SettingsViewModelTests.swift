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

    func testAddPerson_adds3rdPersonAtTheVeryEndOfPeopleViewModel() {
        whenPeopleAdded(2)

        sut.addPerson()

        XCTAssertEqual(sut.peopleViewModel.last?.placeHolder, "3rd person")
    }

    func testAddPerson_withTwoPeople_adds4thPersonAtTheVeryEndOfPeopleViewModel() {
        whenPeopleAdded(2)

        sut.addPerson()
        sut.addPerson()

        XCTAssertEqual(sut.peopleViewModel.last?.placeHolder, "4th person")
    }

    func testAddPerson_adds1stPersonToPeopleViewModel() {
        whenPeopleAdded(1)
        XCTAssertEqual(sut.peopleViewModel.last?.placeHolder, "1st person")
    }

    func testAddPerson_withTwoPeople_addsTwoEmptyPersonNamesToPeopleViewModel() {
        whenPeopleAdded(2)
        XCTAssertEqual(sut.peopleViewModel.count, 2)
    }

    func testCanAddPerson_callsCanAddPersonOnPeopleService() {
        _ = sut.canAddPerson()
        XCTAssertTrue(peopleService.canAddPersonHasBeenCalled)
    }

    func testCanRemovePerson_callsCanRemovePersonOnPeopleService() {
        _ = sut.canRemovePerson()
        XCTAssertTrue(peopleService.canRemovePersonHasBeenCalled)
    }

    func testIndexOfPerson_returnsIndexOfPerson() {
        whenPeopleAdded(5)
        let thirdPerson = sut.peopleViewModel[2]
        XCTAssertEqual(sut.index(of: thirdPerson), 2)
    }
}
