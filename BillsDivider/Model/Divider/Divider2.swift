import Foundation

struct Divider2 {
    func divide(_ positions: [ReceiptPosition2], between people: [Person]) -> DivisionResult2 {
        guard people.count >= 2 else { return .noDebt }
        return positions.reduce(into: DivisionResult2.noDebt) { $0 = add($0, divide($1, between: people)) }
    }

    private func divide(_ position: ReceiptPosition2, between people: [Person]) -> DivisionResult2 {
        guard canDivide(position) else { return .noDebt }

        let amount = position.owner == .all ? position.amount / Decimal(people.count) : position.amount
        let debtor = getDebtors(for: position, from: people)[0]
        return .debt(lender: position.buyer, debtor: debtor, amount: amount)
    }

    private func canDivide(_ position: ReceiptPosition2) -> Bool {
        position.amount != 0 && position.buyer.isNotEqualTo(position.owner)
    }

    private func getDebtors(for position: ReceiptPosition2, from people: [Person]) -> [Buyer2] {
        switch position.owner {
        case .all:
            return people.filter { $0.id != position.buyer.asPerson.id }.map { .person($0) }
        case .person(let debtor):
            return [.person(debtor)]
        }
    }

    private func add(_ leftResult: DivisionResult2, _ rightResult: DivisionResult2) -> DivisionResult2 {
        switch (leftResult, rightResult) {
        case (.noDebt, _):
            return rightResult
        case (_, .noDebt):
            return leftResult
        case let (.debt(leftLender, leftDebtor, leftAmount), .debt(rightLender, rightDebtor, rightAmount)):
            return calculateDebt(
                (leftLender, leftDebtor, leftAmount),
                (rightLender, rightDebtor, rightAmount)
            )
        }
    }

    private func calculateDebt(
        _ left: (lender: Buyer2, debtor: Buyer2, amount: Decimal),
        _ right: (lender: Buyer2, debtor: Buyer2, amount: Decimal)
    ) -> DivisionResult2 {
        if left.lender == right.lender {
            let totalAmount = left.amount + right.amount
            return .debt(lender: left.lender, debtor: left.debtor, amount: totalAmount)
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
