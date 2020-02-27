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
    public let colors: PersonColors

    public init(
        id: UUID = .init(),
        name: String,
        state: State = .default,
        colors: PersonColors = .default
    ) {
        if id == .empty, state != .empty {
            assertionFailure("If empty Id, State must be also empty")
        }

        if id != .empty, state == .empty {
            assertionFailure("If empty State, Id must be also empty")
        }

        if name.first?.isNumber == true, name.contains("person"), state != .generated {
            assertionFailure("If Name is generated, State must be also generated")
        }

        self.id = id
        self.name = name
        self.state = state
        self.colors = colors
    }

    private static var numberFormatter: NumberFormatter {
        .oridinalNumberFormatter
    }

    public func withUpdated(name: String, andNumber number: Int? = nil) -> Person {
        let id = state == .empty ? UUID() : self.id

        if !name.isEmpty {
            return .init(id: id, name: name, colors: colors)
        }

        guard let number = number else {
            return .empty
        }

        let formattedNumber = Self.numberFormatter.format(value: number)
        return .init(id: id, name: "\(formattedNumber) person", state: .generated, colors: colors)
    }

    public func withUpdatedColors(_ colors: PersonColors) -> Person {
        .init(id: id, name: name, state: state, colors: colors)
    }

    public static var empty: Person {
        .init(id: .empty, name: "", state: .empty, colors: .default)
    }

    public static func withName(_ name: String) -> Person {
        .init(name: name, colors: .default)
    }

    public static func withGeneratedName(forNumber number: Int) -> Person {
        .init(name: "\(numberFormatter.format(value: number)) person", state: .generated, colors: .default)
    }
}

extension Person: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(Person.self)(id: \(id), name: \(name), state: \(state), colors: \(colors))"
    }
}
