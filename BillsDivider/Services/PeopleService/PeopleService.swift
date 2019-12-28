import Combine

protocol PeopleService {
    var maximumNumberOfPeople: Int { get }
    var minimumNumberOfPeople: Int { get }

    var peopleDidUpdate: AnyPublisher<[Person], Never> { get }
    
    func getNumberOfPeople() -> Int
    func fetchPeople() -> [Person]
    func updatePeople(_ people: [Person])

    func canAddPerson() -> Bool
    func canRemovePerson() -> Bool
}

extension PeopleService {
    func canAddPerson() -> Bool {
        getNumberOfPeople() < maximumNumberOfPeople
    }

    func canRemovePerson() -> Bool {
        getNumberOfPeople() > minimumNumberOfPeople
    }
}
