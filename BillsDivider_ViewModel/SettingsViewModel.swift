import BillsDivider_Model
import Combine
import Foundation

public final class SettingsViewModel: ObservableObject {
    @Published public var people: People
    @Published public var peopleNames: [String]

    private let peopleService: PeopleService
    private var subscriptions: [AnyCancellable]

    public init(peopleService: PeopleService) {
        self.peopleService = peopleService
        self.people = peopleService.fetchPeople()
        self.peopleNames = []
        self.subscriptions = []

        self.peopleNames = self.people.map { name(for: $0) }
        self.bind()
    }

    public func addPerson() {
        let nextPersonsIndex = people.count + 1
        people = people.appending(.withGeneratedName(forNumber: nextPersonsIndex))
    }

    private func bind() {
        $people
            .sink { [weak self] in self?.onPeopleChange(with: $0) }
            .store(in: &subscriptions)

        $peopleNames
            .dropFirst(2)
            .debounce(for: .seconds(0.25), scheduler: DispatchQueue.main)
            .sink { [weak self] in self?.onPeopleNamesChange(with: $0) }
            .store(in: &subscriptions)
    }

    private func onPeopleChange(with people: People) {
        peopleNames = people.map { name(for: $0) }
        peopleService.updatePeople(people)
    }

    private func onPeopleNamesChange(with names: [String]) {
        guard names != people.map({ name(for: $0) }) else { return }
        people = people.enumerated().map { $1.withUpdated(name: names[$0], andNumber: $0 + 1)}.asPeople
    }

    public func canAddPerson() -> Bool {
        peopleService.canAddPerson()
    }

    public func canRemovePerson() -> Bool {
        peopleService.canRemovePerson()
    }

    public func placeholder(for person: Person) -> String {
        person.state == .generated ? person.name : ""
    }

    public func name(for person: Person) -> String {
        person.state == .generated ? "" : person.name
    }

    public func index(of person: Person) -> Int {
        guard let index = people.firstIndex(of: person) else {
            preconditionFailure("Given person does not exist in people list")
        }

        return index
    }
}
