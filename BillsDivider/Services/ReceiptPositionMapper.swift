import CoreData

struct ReceiptPositionMapper {
    func map(
        _ position: ReceiptPosition,
        _ orderNumber: Int,
        _ context: NSManagedObjectContext
    ) -> ReceiptPositionEntity {
        let entity = ReceiptPositionEntity(context: context)
        entity.id = position.id
        entity.amount = NSDecimalNumber(decimal: position.amount)
        entity.buyer = String(describing: position.buyer)
        entity.owner = String(describing: position.owner)
        entity.orderNumber = Int32(orderNumber)
        return entity
    }

    func map(_ entity: ReceiptPositionEntity) -> ReceiptPosition? {
        guard
            let id = entity.id,
            let amount = entity.amount?.decimalValue,
            let buyer = Buyer.from(string: entity.buyer ?? ""),
            let owner = Owner.from(string: entity.owner ?? "")
        else { return nil }

        return .init(id: id, amount: amount, buyer: buyer, owner: owner)
    }
}
