public struct PersonColors: Equatable, Hashable {
    public let background: BDColor
    public let foreground: BDColor

    private init(background: BDColor, foreground: BDColor) {
        self.background = background
        self.foreground = foreground
    }

    public static var `default`: PersonColors {
        .fromColor(.green)
    }

    public static func fromColor(_ color: BDColor) -> PersonColors {
        switch color {
        case .black: return .default
        case .white: return .init(background: .white, foreground: .black)
        case .blue: return .init(background: .blue, foreground: .white)
        case .green: return .init(background: .green, foreground: .white)
        case .purple: return .init(background: .purple, foreground: .white)
        case .pink: return .init(background: .pink, foreground: .white)
        case .red: return .init(background: .red, foreground: .white)
        case .orange: return .init(background: .orange, foreground: .white)
        }
    }
}
