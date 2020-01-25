public enum SumResult: Equatable {
    case zero
    case value(amount: Decimal)

    public var amount: Decimal {
        if case let .value(amount) = self {
            return amount
        }
        return 0
    }

    public static func from(values: [Decimal]) -> Self {
        let amount = values.reduce(0, +)
        return amount > 0 ? .value(amount: amount) : .zero
    }
}
