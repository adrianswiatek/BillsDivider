enum Owner {
    case me
    case notMe
    case all

    var formatted: String {
        switch self {
        case .me: return "Me"
        case .notMe: return "Not me"
        case .all: return "All"
        }
    }
}
