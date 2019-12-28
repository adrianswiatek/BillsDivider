import Foundation

struct Person: Equatable, Hashable, Identifiable {
    enum State {
        case `default`
        case empty
        case generated
    }

    let id: UUID
    let name: String
    let state: Person.State

    private static var numberFormatter: NumberFormatter {
        .oridinalNumberFormatter
    }

    private init(id: UUID, name: String, state: State = .default) {
        self.id = id
        self.name = name
        self.state = state
    }

    private init(name: String, state: State = .default) {
        self.init(id: UUID(), name: name, state: state)
    }

    func withUpdated(name: String, andNumber number: Int? = nil) -> Person {
        if name != "" {
            return .init(id: id, name: name)
        }

        guard let number = number else {
            return .init(id: id, name: name)
        }

        return .init(id: id, name: "\(Self.numberFormatter.format(value: number)) person", state: .generated)
    }

    static var empty: Person {
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, name: "", state: .empty)
    }

    static func withName(_ name: String) -> Person {
        .init(name: name)
    }

    static func withGeneratedName(forNumber number: Int) -> Person {
        .init(name: "\(numberFormatter.format(value: number)) person", state: .generated)
    }
}

extension Person: CustomDebugStringConvertible {
    var debugDescription: String {
        "\(Person.self)(id: \(id), name: \(name), state: \(state))"
    }
}
