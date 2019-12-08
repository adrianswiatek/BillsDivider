enum Buyer {
    case me
    case notMe

    var formatted: String {
        switch self {
        case .me: return "Me"
        case .notMe: return "They"
        }
    }

    func isEqualTo(owner: Owner) -> Bool {
        switch (self, owner) {
        case (.me, .me), (.notMe, .notMe):
            return true
        default:
            return false
        }
    }

    func isNotEqualTo(owner: Owner) -> Bool {
        !isEqualTo(owner: owner)
    }

    func next() -> Buyer {
        switch self {
        case .me:
            return .notMe
        case .notMe:
            return .me
        }
    }
}
