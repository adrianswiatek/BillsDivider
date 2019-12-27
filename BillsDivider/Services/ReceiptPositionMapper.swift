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
        entity.buyer = position.buyer.asPerson.id.uuidString
        entity.owner = position.owner.asPerson?.id.uuidString ?? Owner.all.formatted
        entity.orderNumber = Int32(orderNumber)
        return entity
    }

    func map(_ entity: ReceiptPositionEntity, _ people: [Person]) -> ReceiptPosition? {
        guard
            let id = entity.id,
            let amount = entity.amount?.decimalValue,
            let buyer = getBuyer(from: entity, and: people)
        else { return nil }

        let owner = getOwner(from: entity, and: people)
        return .init(id: id, amount: amount, buyer: buyer, owner: owner)
    }

    private func getBuyer(from entity: ReceiptPositionEntity, and people: [Person]) -> Buyer? {
        guard let person = people.first(where: { $0.id == UUID(uuidString: entity.buyer ?? "") }) else {
            return nil
        }
        return .person(person)
    }

    private func getOwner(from entity: ReceiptPositionEntity, and people: [Person]) -> Owner {
        guard let person = people.first(where: { $0.id == UUID(uuidString: entity.owner ?? "") }) else {
            return .all
        }
        return .person(person)
    }
}
