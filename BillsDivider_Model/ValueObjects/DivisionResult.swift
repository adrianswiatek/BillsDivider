import Foundation

public enum DivisionResult {
    case noDebt
    case debt(lender: Buyer, debtor: Buyer, amount: Decimal)

    public var debtAmount: Decimal {
        if case let .debt(_, _, amount) = self {
            return amount
        }
        return 0
    }
}

extension DivisionResult: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.noDebt, .noDebt):
            return true
        case (.noDebt, .debt), (.debt, .noDebt):
            return false
        case let (.debt(leftLender, leftDebtor, leftAmount), .debt(rightLender, rightDebtor, rightAmount)):
            return leftLender == rightLender && leftDebtor == rightDebtor && leftAmount == rightAmount
        }
    }
}
