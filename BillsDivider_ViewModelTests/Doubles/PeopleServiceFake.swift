@testable import BillsDivider
@testable import BillsDivider_Model
import Combine

class PeopleServiceFake: PeopleService {
    var maximumNumberOfPeople: Int
    var minimumNumberOfPeople: Int

    var peopleDidUpdate: AnyPublisher<People, Never> {
        peopleDidUpdateSubject.eraseToAnyPublisher()
    }

    private let peopleDidUpdateSubject: PassthroughSubject<People, Never>
    private var people: People

    var updatePeopleHasBeenCalled: Bool = false
    var updatePersonHasBeenCalled: Bool = false
    var canAddPersonHasBeenCalled: Bool = true
    var canRemovePersonHasBeenCalled: Bool = false

    init() {
        self.peopleDidUpdateSubject = .init()
        self.maximumNumberOfPeople = 2
        self.minimumNumberOfPeople = 2
        self.people = .empty
    }

    func numberOfPeople() -> Int {
        people.count
    }

    func fetchPeople() -> People {
        people
    }

    func updatePeople(_ people: People) {
        self.people = people
        peopleDidUpdateSubject.send(people)
        updatePeopleHasBeenCalled = true
    }

    func updatePerson(_ person: Person) {
        people = people.updating(person)
        peopleDidUpdateSubject.send(people)
        updatePersonHasBeenCalled = true
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
