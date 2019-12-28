import Combine

final class InMemoryPeopleService: PeopleService {
    var peopleDidUpdate: AnyPublisher<[Person], Never> {
        peopleDidUpdateSubject.eraseToAnyPublisher()
    }

    let maximumNumberOfPeople: Int
    let minimumNumberOfPeople: Int

    private let peopleDidUpdateSubject: CurrentValueSubject<[Person], Never>
    private var people: [Person]

    init(maximumNumberOfPeople: Int) {
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
}
