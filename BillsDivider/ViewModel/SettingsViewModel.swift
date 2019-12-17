import Combine
import Foundation

final class SettingsViewModel: ObservableObject {
    @Published var people: [String]

    init() {
        self.people = ["Me", "2nd person"]
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

    func removePerson() {
        guard people.count > 2 else {
            return
        }

        people.removeLast()
    }
}
