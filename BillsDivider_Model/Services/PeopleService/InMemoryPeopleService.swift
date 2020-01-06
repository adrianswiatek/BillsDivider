import Combine

public final class InMemoryPeopleService: PeopleService {
    public var peopleDidUpdate: AnyPublisher<People, Never> {
        peopleDidUpdateSubject.eraseToAnyPublisher()
    }

    public let maximumNumberOfPeople: Int
    public let minimumNumberOfPeople: Int

    private let peopleDidUpdateSubject: CurrentValueSubject<People, Never>
    private var people: People

    public init(maximumNumberOfPeople: Int) {
        self.maximumNumberOfPeople = maximumNumberOfPeople
        self.minimumNumberOfPeople = 2
        self.peopleDidUpdateSubject = .init(.empty)
        self.people = .empty
    }

    public func numberOfPeople() -> Int {
        people.count
    }

    public func fetchPeople() -> People {
        people
    }

    public func updatePeople(_ people: People) {
        self.people = people
        self.peopleDidUpdateSubject.send(people)
    }
}
