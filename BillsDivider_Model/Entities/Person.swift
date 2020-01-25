import Foundation

public struct Person: Equatable, Hashable, Identifiable {
    public enum State: String {
        case `default`
        case empty
        case generated
    }

    public let id: UUID
    public let name: String
    public let state: State

    private static var emptyUuid = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!

    public init(id: UUID = .init(), name: String, state: State = .default) {
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

    public func withUpdated(name: String, andNumber number: Int? = nil) -> Person {
        let id = state == .empty ? UUID() : self.id

        if !name.isEmpty {
            return .init(id: id, name: name)
        }

        guard let number = number else {
            return .empty
        }

        let formattedNumber = Self.numberFormatter.format(value: number)
        return .init(id: id, name: "\(formattedNumber) person", state: .generated)
    }

    public static var empty: Person {
        .init(id: Self.emptyUuid, name: "", state: .empty)
    }

    public static func withName(_ name: String) -> Person {
        .init(name: name)
    }

    public static func withGeneratedName(forNumber number: Int) -> Person {
        .init(name: "\(numberFormatter.format(value: number)) person", state: .generated)
    }
}

extension Person: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(Person.self)(id: \(id), name: \(name), state: \(state))"
    }
}