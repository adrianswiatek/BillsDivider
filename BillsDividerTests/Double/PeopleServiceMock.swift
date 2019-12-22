@testable import BillsDivider

class PeopleServiceMock: PeopleService {
    var addPersonHasBeenCalled: Bool = false
    var canRemovePersonHasBeenCalled: Bool = false

    func getNumberOfPeople() -> Int { 0 }
    func fetchPeople() -> [Person] { [] }

    func addPerson(_ person: Person) {
        addPersonHasBeenCalled = true
    }

    func removePerson(_ person: Person) {}
    func updatePerson(_ person: Person) {}

    func canRemovePerson() -> Bool {
        canRemovePersonHasBeenCalled = true
        return true
    }
}
