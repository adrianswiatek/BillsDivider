import BillsDivider_Model
import SwiftUI

public struct ReceiptPositionViewModel: Identifiable {
    public let id: UUID
    public let price: String
    public let discount: String?
    public let priceWithDiscount: String
    public let buyerColor: Color
    public let ownerColor: Color

    public init(
        _ position: ReceiptPosition,
        _ people: People,
        _ numberFormatter: NumberFormatter
    ) {
        self.id = position.id
        self.priceWithDiscount = numberFormatter.format(value: position.amountWithDiscount)
        self.price = numberFormatter.format(value: position.amount)
        self.discount = position.discount.map { numberFormatter.format(value: $0) }

        guard let buyerColor = people.findBy(id: position.buyer.asPerson.id)?.colors.background.asColor else {
            preconditionFailure("Unable to find expected person in people instance.")
        }

        self.buyerColor = buyerColor

        let ownerColor = position.owner.asPerson
            .map { $0.id }
            .flatMap { people.findBy(id: $0) }
            .map { $0.colors.background.asColor }

        self.ownerColor = ownerColor ?? .secondary
    }
}
