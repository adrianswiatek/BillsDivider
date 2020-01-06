public enum Buyer: Hashable {
    case person(Person)

    public var asPerson: Person {
        guard case let .person(person) = self else {
            preconditionFailure("self must be a person")
        }
        return person
    }

    public var formatted: String {
        switch self {
        case .person(let person):
            return person.name
        }
    }

    public func isEqualTo(_ owner: Owner) -> Bool {
        switch (self, owner) {
        case (_, .all):
            return false
        case let (.person(buyerPerson), .person(ownerPerson)):
            return buyerPerson == ownerPerson
        }
    }

    public func isNotEqualTo(_ owner: Owner) -> Bool {
        !isEqualTo(owner)
    }
}

extension Buyer: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.person(lhsPerson), .person(rhsPerson)):
            return lhsPerson == rhsPerson
        }
    }
}
