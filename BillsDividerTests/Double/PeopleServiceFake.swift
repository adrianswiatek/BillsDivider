@testable import BillsDivider

class PeopleServiceFake: PeopleService {
    private var people: [Person] = []

    var updatePeopleHasBeenCalled: Bool = false
    var canAddPersonHasBeenCalled: Bool = true
    var canRemovePersonHasBeenCalled: Bool = false

    required init(maximumNumberOfPeople: Int = 2) {}

    func getNumberOfPeople() -> Int {
        people.count
    }

    func fetchPeople() -> [Person] {
        people
    }

    func updatePeople(_ people: [Person]) {
        self.people = people
        updatePeopleHasBeenCalled = true
    }

    func canAddPerson() -> Bool {
        canAddPersonHasBeenCalled = true
        return true
    }

    func canRemovePerson() -> Bool {
        canRemovePersonHasBeenCalled = true
        return true
    }
}
