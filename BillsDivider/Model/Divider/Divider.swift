import Foundation

struct Divider {
    func divide(_ positions: [ReceiptPosition]) -> BillsDivisionResult {
        positions.reduce(into: BillsDivisionResult.noDebt) { $0 = add($0, divide($1)) }
    }

    private func divide(_ position: ReceiptPosition) -> BillsDivisionResult {
        guard position.amount != 0, position.buyer.isNotEqualTo(owner: position.owner) else {
            return .noDebt
        }

        let amount = position.owner == .all ? position.amount / 2 : position.amount
        return .debt(lender: position.buyer, debtor: position.buyer.next(), amount: amount)
    }

    private func add(
        _ leftResult: BillsDivisionResult,
        _ rightResult: BillsDivisionResult
    ) -> BillsDivisionResult {
        switch (leftResult, rightResult) {
        case (.noDebt, _):
            return rightResult
        case (_, .noDebt):
            return leftResult
        case let (.debt(leftLender, _, leftAmount), .debt(rightLender, _, rightAmount)):
            return calculateDebt((leftLender, leftAmount), (rightLender, rightAmount))
        }
    }

    private func calculateDebt(
        _ left: (lender: Buyer, amount: Decimal),
        _ right: (lender: Buyer, amount: Decimal)
    ) -> BillsDivisionResult {
        if left.lender == right.lender {
            let totalAmount = left.amount + right.amount
            return .debt(lender: left.lender, debtor: left.lender.next(), amount: totalAmount)
        }

        if left.amount > right.amount {
            let totalAmount = left.amount - right.amount
            return .debt(lender: left.lender, debtor: right.lender, amount: totalAmount)
        }

        if left.amount < right.amount {
            let totalAmount = right.amount - left.amount
            return .debt(lender: right.lender, debtor: left.lender, amount: totalAmount)
        }

        return .noDebt
    }
}
