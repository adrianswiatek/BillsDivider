import Combine
import Foundation

final class SettingsViewModel: ObservableObject {
    @Published var people: [String]

    private let maximumNumberOfPeople: Int
    private let minimumNumberOfPeople: Int

    private let peopleService: PeopleService

    init(peopleService: PeopleService, maximumNumberOfPeople: Int) {
        self.peopleService = peopleService
        self.maximumNumberOfPeople = maximumNumberOfPeople
        self.minimumNumberOfPeople = 2
        self.people = []

        (0..<minimumNumberOfPeople).forEach { _ in addPerson() }
    }

    func addPerson() {
        let nextPersonsIndex = people.count + 1
        people.append(generatePersonsName(for: nextPersonsIndex))
    }

    private func generatePersonsName(for index: Int) -> String {
        let oridinalNumberFormatter = NumberFormatter()
        oridinalNumberFormatter.numberStyle = .ordinal

        guard let oridinalNumber = oridinalNumberFormatter.string(for: index) else {
            preconditionFailure("Can not format given argument.")
        }

        return "\(oridinalNumber) person"
    }

    func canAddPerson() -> Bool {
        people.count < maximumNumberOfPeople
    }

    func canRemovePerson(atIndex index: Int) -> Bool {
        index > minimumNumberOfPeople - 1
    }
}
