enum Owner2 {
    case person(Person)
    case all

    var formatted: String {
        switch self {
        case .person(let person):
            return person.name
        case .all:
            return "All"
        }
    }
}

extension Owner2: Equatable {
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
