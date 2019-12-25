import Combine

class InMemoryPeopleService: PeopleService {
    var peopleDidUpdate: AnyPublisher<[Person], Never> {
        peopleDidUpdateSubject.eraseToAnyPublisher()
    }

    private var peopleDidUpdateSubject: CurrentValueSubject<[Person], Never>
    private var people: [Person]

    private let maximumNumberOfPeople: Int
    private let minimumNumberOfPeople: Int

    required init(maximumNumberOfPeople: Int = 2) {
        self.maximumNumberOfPeople = maximumNumberOfPeople
        self.minimumNumberOfPeople = 2
        self.peopleDidUpdateSubject = .init([])
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
        self.peopleDidUpdateSubject.send(people)
    }

    func canAddPerson() -> Bool {
        getNumberOfPeople() < maximumNumberOfPeople
    }

    func canRemovePerson() -> Bool {
        getNumberOfPeople() > minimumNumberOfPeople
    }
}
