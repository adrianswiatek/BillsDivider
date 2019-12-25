enum Buyer2 {
    case person(Person)

    var asPerson: Person {
        guard case let .person(person) = self else {
            preconditionFailure("self must be a person")
        }
        return person
    }

    var formatted: String {
        switch self {
        case .person(let person):
            return person.name
        }
    }

    func isEqualTo(_ owner: Owner2) -> Bool {
        switch (self, owner) {
        case (_, .all):
            return false
        case let (.person(buyerPerson), .person(ownerPerson)):
            return buyerPerson == ownerPerson
        }
    }

    func isNotEqualTo(_ owner: Owner2) -> Bool {
        !isEqualTo(owner)
    }
}

extension Buyer2: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.person(lhsPerson), .person(rhsPerson)):
            return lhsPerson == rhsPerson
        }
    }
}
