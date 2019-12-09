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

    static func from(string: String) -> Owner? {
        switch string {
        case "me":
            return .me
        case "notMe":
            return .notMe
        case "all":
            return .all
        default:
            return nil
        }
    }
}
