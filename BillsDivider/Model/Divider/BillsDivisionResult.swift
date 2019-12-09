import Foundation

enum BillsDivisionResult {
    case noDebt
    case debt(lender: Buyer, debtor: Buyer, amount: Decimal)

    var debtAmount: Decimal {
        if case let .debt(_, _, amount) = self {
            return amount
        }
        return 0
    }
}

extension BillsDivisionResult: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.noDebt, .noDebt):
            return true
        case (.noDebt, .debt):
            return false
        case (.debt, .noDebt):
            return false
        case let (.debt(leftLender, leftDebtor, leftAmount), .debt(rightLender, rightDebtor, rightAmount)):
            return leftLender == rightLender && leftDebtor == rightDebtor && leftAmount == rightAmount
        }
    }
}
