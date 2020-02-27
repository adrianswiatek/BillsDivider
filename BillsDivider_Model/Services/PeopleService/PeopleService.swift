import Combine

public protocol PeopleService {
    var maximumNumberOfPeople: Int { get }
    var minimumNumberOfPeople: Int { get }

    var peopleDidUpdate: AnyPublisher<People, Never> { get }
    
    func numberOfPeople() -> Int
    func fetchPeople() -> People
    func updatePeople(_ people: People)
    func updatePerson(_ person: Person)

    func canAddPerson() -> Bool
    func canRemovePerson() -> Bool
}

extension PeopleService {
    public func canAddPerson() -> Bool {
        numberOfPeople() < maximumNumberOfPeople
    }

    public func canRemovePerson() -> Bool {
        numberOfPeople() > minimumNumberOfPeople
    }
}
