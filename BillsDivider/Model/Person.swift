import Foundation

struct Person: Equatable, Hashable, Identifiable {
    enum State: String {
        case `default`
        case empty
        case generated
    }

    let id: UUID
    let name: String
    let state: State

    private static var emptyUuid = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!

    init(id: UUID = .init(), name: String, state: State = .default) {
        if id == Self.emptyUuid, state != .empty {
            assertionFailure("If empty Id, State must be also empty")
        }

        if id != Self.emptyUuid, state == .empty {
            assertionFailure("If empty State, Id must be also empty")
        }

        if name.first?.isNumber == true, name.contains("person"), state != .generated {
            assertionFailure("If Name is generated, State must be also generated")
        }

        self.id = id
        self.name = name
        self.state = state
    }

    private static var numberFormatter: NumberFormatter {
        .oridinalNumberFormatter
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
        .init(id: Self.emptyUuid, name: "", state: .empty)
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
