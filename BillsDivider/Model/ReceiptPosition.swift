import Foundation

struct ReceiptPosition: Identifiable {
    let id: UUID
    let amount: Decimal
    let buyer: Buyer
    let owner: Owner

    static var empty: ReceiptPosition {
        return ReceiptPosition(amount: 0, buyer: .me, owner: .all)
    }
}

extension ReceiptPosition {
    init(amount: Decimal, buyer: Buyer, owner: Owner) {
        self.id = UUID()
        self.amount = amount
        self.buyer = buyer
        self.owner = owner
    }
}

extension ReceiptPosition: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.amount == rhs.amount && lhs.buyer == rhs.buyer && lhs.owner == rhs.owner
    }
}
