import Foundation

struct ReceiptPosition: Identifiable {
    let id: UUID
    let amount: Double
    let buyer: Buyer
    let owner: Owner

    static var empty: ReceiptPosition {
        return ReceiptPosition(amount: 0, buyer: .me, owner: .me)
    }
}

extension ReceiptPosition {
    init(amount: Double, buyer: Buyer, owner: Owner) {
        self.id = UUID()
        self.amount = amount
        self.buyer = buyer
        self.owner = owner
    }
}
