protocol PeopleService {
    init(maximumNumberOfPeople: Int)
    
    func getNumberOfPeople() -> Int
    func fetchPeople() -> [Person]
    func updatePeople(_ people: [Person])

    func canAddPerson() -> Bool
    func canRemovePerson() -> Bool
}
