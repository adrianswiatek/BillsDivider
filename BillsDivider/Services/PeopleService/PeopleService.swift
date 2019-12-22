protocol PeopleService {
    func getNumberOfPeople() -> Int
    func fetchPeople() -> [Person]
    func addPerson(_ person: Person)
    func removePerson(_ person: Person)
    func updatePerson(_ person: Person)
    func canRemovePerson() -> Bool
}
