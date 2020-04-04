import Foundation

public struct PositionsDivider {
    public init() {}

    public func divide(_ positions: [ReceiptPosition], between people: People) -> DivisionResult {
        guard people.count >= 2 else { return .noDebt }
        return positions.reduce(into: DivisionResult.noDebt) { $0 = add($0, divide($1, between: people)) }
    }

    private func divide(_ position: ReceiptPosition, between people: People) -> DivisionResult {
        guard canDivide(position) else { return .noDebt }

        let debtor = getDebtors(for: position, from: people)[0]
        return .debt(lender: position.buyer, debtor: debtor, amount: amount(position, people))
    }

    private func amount(_ position: ReceiptPosition, _ people: People) -> Decimal {
        position.owner == .all ? position.amountWithDiscount / Decimal(people.count) : position.amountWithDiscount
    }

    private func canDivide(_ position: ReceiptPosition) -> Bool {
        position.amountWithDiscount != 0 && position.buyer.isNotEqualTo(position.owner)
    }

    private func getDebtors(for position: ReceiptPosition, from people: People) -> [Buyer] {
        switch position.owner {
        case .all:
            return people.filter { $0.id != position.buyer.asPerson.id }.map { .person($0) }
        case .person(let debtor):
            return [.person(debtor)]
        }
    }

    private func add(_ leftResult: DivisionResult, _ rightResult: DivisionResult) -> DivisionResult {
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
        _ left: (lender: Buyer, debtor: Buyer, amount: Decimal),
        _ right: (lender: Buyer, debtor: Buyer, amount: Decimal)
    ) -> DivisionResult {
        if left.lender == right.lender {
            let totalAmount = left.amount + right.amount
            return divisionResult(lender: left.lender, debtor: left.debtor, amount: totalAmount)
        }

        if left.amount > right.amount {
            let totalAmount = left.amount - right.amount
            return divisionResult(lender: left.lender, debtor: right.lender, amount: totalAmount)
        }

        if left.amount < right.amount {
            let totalAmount = right.amount - left.amount
            return divisionResult(lender: right.lender, debtor: left.lender, amount: totalAmount)
        }

        return .noDebt
    }

    private func divisionResult(lender: Buyer, debtor: Buyer, amount: Decimal) -> DivisionResult {
        amount != 0 ? .debt(lender: lender, debtor: debtor, amount: amount) : .noDebt
    }
}
