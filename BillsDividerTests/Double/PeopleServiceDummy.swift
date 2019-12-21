@testable import BillsDivider

class PeopleServiceDummy: PeopleService {
    func getNumberOfPeople() -> Int { 0 }
    func fetchPeople() -> [Person] { [] }
    func addPerson(_ person: Person) {}
    func removePerson(_ person: Person) {}
    func updatePerson(_ person: Person) {}
}
