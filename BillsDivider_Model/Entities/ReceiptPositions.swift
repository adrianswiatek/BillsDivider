import Foundation

public struct ReceiptPosition: Identifiable {
    public let id: UUID
    public let amount: Decimal
    public let discount: Decimal?
    public let buyer: Buyer
    public let owner: Owner

    public var amountWithDiscount: Decimal {
        if let discount = discount {
            return amount - discount
        }
        return amount
    }

    public var hasDiscount: Bool {
        discount != nil
    }

    public static var empty: ReceiptPosition {
        .init(amount: 0, buyer: .person(.empty), owner: .all)
    }

    public init(id: UUID, amount: Decimal, discount: Decimal? = nil, buyer: Buyer, owner: Owner) {
        self.id = id
        self.amount = amount
        self.discount = discount
        self.buyer = buyer
        self.owner = owner
    }

    public init(amount: Decimal, discount: Decimal? = nil, buyer: Buyer, owner: Owner) {
        self.init(id: UUID(), amount: amount, discount: discount, buyer: buyer, owner: owner)
    }
}

extension ReceiptPosition: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.amount == rhs.amount && lhs.buyer == rhs.buyer && lhs.owner == rhs.owner
    }
}
