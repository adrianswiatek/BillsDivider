import Combine

protocol PeopleService {
    var maximumNumberOfPeople: Int { get }
    var minimumNumberOfPeople: Int { get }

    var peopleDidUpdate: AnyPublisher<[Person], Never> { get }
    
    func numberOfPeople() -> Int
    func fetchPeople() -> [Person]
    func updatePeople(_ people: [Person])

    func canAddPerson() -> Bool
    func canRemovePerson() -> Bool
}

extension PeopleService {
    func canAddPerson() -> Bool {
        numberOfPeople() < maximumNumberOfPeople
    }

    func canRemovePerson() -> Bool {
        numberOfPeople() > minimumNumberOfPeople
    }
}
