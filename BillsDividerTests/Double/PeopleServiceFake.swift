@testable import BillsDivider
import Combine

class PeopleServiceFake: PeopleService {
    var maximumNumberOfPeople: Int
    var minimumNumberOfPeople: Int

    var peopleDidUpdate: AnyPublisher<[Person], Never> {
        peopleDidUpdateSubject.eraseToAnyPublisher()
    }

    private let peopleDidUpdateSubject: PassthroughSubject<[Person], Never>
    private var people: [Person]

    var updatePeopleHasBeenCalled: Bool = false
    var canAddPersonHasBeenCalled: Bool = true
    var canRemovePersonHasBeenCalled: Bool = false

    init() {
        self.peopleDidUpdateSubject = .init()
        self.maximumNumberOfPeople = 2
        self.minimumNumberOfPeople = 2
        self.people = []
    }

    func getNumberOfPeople() -> Int {
        people.count
    }

    func fetchPeople() -> [Person] {
        people
    }

    func updatePeople(_ people: [Person]) {
        self.people = people
        peopleDidUpdateSubject.send(people)
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
