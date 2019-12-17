import Combine
import Foundation

final class SettingsViewModel: ObservableObject {
    @Published var people: [String]

    let peopleRange: ClosedRange<Int>

    var numberOfPeople: Int {
        get {
            people.count
        }
        set {
            let difference = newValue - numberOfPeople
            if difference > 0 {
                (0..<difference).forEach { _ in addPerson() }
            } else if difference < 0 {
                (difference..<0).forEach { _ in removePerson() }
            }
        }
    }

    init() {
        people = []

        let minimumNumberOfPeople = 2
        let maximumNumberOfPeople = 3
        peopleRange = minimumNumberOfPeople...maximumNumberOfPeople

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

    func removePerson() {
        guard people.count > 2 else {
            return
        }

        people.removeLast()
    }
}
