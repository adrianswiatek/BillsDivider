enum Buyer {
    case me
    case notMe

    var formatted: String {
        switch self {
        case .me: return "Me"
        case .notMe: return "Not me"
        }
    }
}
