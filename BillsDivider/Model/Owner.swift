enum Owner {
    case person(Person)
    case all

    var asPerson: Person? {
        guard case let .person(person) = self else {
            return nil
        }
        return person
    }

    var formatted: String {
        switch self {
        case .person(let person):
            return person.name
        case .all:
            return "All"
        }
    }
}

extension Owner: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.all, all):
            return true
        case (.all, .person(_)), (.person(_), .all):
            return false
        case (.person(let lhsPerson), .person(let rhsPerson)):
            return lhsPerson == rhsPerson
        }
    }
}

extension Owner: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .person(let person):
            hasher.combine(person)
        case .all:
            hasher.combine(formatted)
        }
    }
}
