import Combine

public final class InMemoryPeopleService: PeopleService {
    public var peopleDidUpdate: AnyPublisher<[Person], Never> {
        peopleDidUpdateSubject.eraseToAnyPublisher()
    }

    public let maximumNumberOfPeople: Int
    public let minimumNumberOfPeople: Int

    private let peopleDidUpdateSubject: CurrentValueSubject<[Person], Never>
    private var people: [Person]

    public init(maximumNumberOfPeople: Int) {
        self.maximumNumberOfPeople = maximumNumberOfPeople
        self.minimumNumberOfPeople = 2
        self.peopleDidUpdateSubject = .init([])
        self.people = []
    }

    public func numberOfPeople() -> Int {
        people.count
    }

    public func fetchPeople() -> [Person] {
        people
    }

    public func updatePeople(_ people: [Person]) {
        self.people = people
        self.peopleDidUpdateSubject.send(people)
    }
}
