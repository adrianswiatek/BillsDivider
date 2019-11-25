enum BillsDivisionResult {
    case noDebt
    case debt(lender: Buyer, debtor: Buyer, amount: Double)

    var debtAmount: Double {
        if case let .debt(_, _, amount) = self {
            return amount
        }
        return 0
    }
}
