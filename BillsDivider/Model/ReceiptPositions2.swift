import Foundation

struct ReceiptPosition2: Identifiable {
    let id: UUID
    let amount: Decimal
    let buyer: Buyer2
    let owner: Owner2

    static var empty: ReceiptPosition2 {
        .init(amount: 0, buyer: .person(.empty), owner: .all)
    }
}

extension ReceiptPosition2 {
    init(amount: Decimal, buyer: Buyer2, owner: Owner2) {
        self.id = UUID()
        self.amount = amount
        self.buyer = buyer
        self.owner = owner
    }
}

extension ReceiptPosition2: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.amount == rhs.amount && lhs.buyer == rhs.buyer && lhs.owner == rhs.owner
    }
}
