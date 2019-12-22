import Foundation

struct Person: Equatable, Identifiable {
    enum State {
        case `default`
        case empty
        case generated
    }

    let id: UUID
    let name: String
    let state: Person.State

    private init(id: UUID, name: String, state: State = .default) {
        self.id = id
        self.name = name
        self.state = state
    }

    private init(name: String, state: State = .default) {
        self.init(id: UUID(), name: name, state: state)
    }

    func withUpdated(name: String) -> Person {
        .init(id: id, name: name)
    }

    static var empty: Person {
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, name: "", state: .empty)
    }

    static func withName(_ name: String) -> Person {
        .init(name: name)
    }

    static func withGeneratedName(forNumber number: Int) -> Person {
        let oridinalNumberFormatter = NumberFormatter()
        oridinalNumberFormatter.numberStyle = .ordinal

        guard let oridinalNumber = oridinalNumberFormatter.string(for: number) else {
            preconditionFailure("Can not format given argument.")
        }

        return .init(name: "\(oridinalNumber) person", state: .generated)
    }
}
