class InMemoryPeopleService: PeopleService {
    private var people: [Person]

    private let maximumNumberOfPeople: Int
    private let minimumNumberOfPeople: Int

    required init(maximumNumberOfPeople: Int = 2) {
        self.maximumNumberOfPeople = maximumNumberOfPeople
        self.minimumNumberOfPeople = 2
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
    }

    func canAddPerson() -> Bool {
        getNumberOfPeople() < maximumNumberOfPeople
    }

    func canRemovePerson() -> Bool {
        getNumberOfPeople() > minimumNumberOfPeople
    }
}
