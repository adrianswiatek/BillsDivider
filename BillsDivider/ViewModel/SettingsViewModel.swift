import Combine
import Foundation

final class SettingsViewModel: ObservableObject {
    @Published var people: [Person]

    private let maximumNumberOfPeople: Int

    private let peopleService: PeopleService
    private var subscriptions: [AnyCancellable]

    init(peopleService: PeopleService, maximumNumberOfPeople: Int) {
        self.peopleService = peopleService
        self.maximumNumberOfPeople = maximumNumberOfPeople
        self.people = peopleService.fetchPeople()
        self.subscriptions = []

        self.bind()
    }

    func addPerson() {
        let nextPersonsIndex = people.count + 1
        people.append(Person.withGeneratedName(forNumber: nextPersonsIndex))
    }

    private func bind() {
        $people
            .sink { [weak self] in self?.onPeopleChange(with: $0) }
            .store(in: &subscriptions)
    }

    private func onPeopleChange(with people: [Person]) {
        let numberOfPeople = peopleService.getNumberOfPeople()

        let personHasBeenAdded = people.count > numberOfPeople
        if personHasBeenAdded, let person = people.last {
            peopleService.addPerson(person)
        }
    }

    func canAddPerson() -> Bool {
        people.count < maximumNumberOfPeople
    }

    func canRemovePerson() -> Bool {
        peopleService.canRemovePerson()
    }

    func getPlaceholder(for person: Person) -> String {
        person.state == .generated ? person.name : ""
    }

    func getName(for person: Person) -> String {
        person.state == .generated ? "" : person.name
    }
}
