class InMemoryPeopleService: PeopleService {
    private var people: [Person]

    init() {
        people = []
    }

    func getNumberOfPeople() -> Int {
        people.count
    }

    func fetchPeople() -> [Person] {
        people
    }

    func addPerson(_ person: Person) {
        people.append(person)
    }

    func removePerson(_ person: Person) {
        people.removeAll { $0 == person }
    }

    func updatePerson(_ person: Person) {
        guard let index = people.firstIndex(where: { $0.id == person.id }) else {
            return
        }

        people[index] = person
    }

    func canRemovePerson() -> Bool {
        getNumberOfPeople() > 2
    }
}
