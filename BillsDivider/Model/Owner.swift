enum Owner {
    case me
    case notMe
    case all

    var formatted: String {
        switch self {
        case .me: return "Me"
        case .notMe: return "They"
        case .all: return "All"
        }
    }
}
