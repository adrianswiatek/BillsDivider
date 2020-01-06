import CoreData

extension ReceiptPosition {
    func asReceiptPositionEntity(orderNumber: Int, context: NSManagedObjectContext) -> ReceiptPositionEntity {
        let entity = ReceiptPositionEntity(context: context)
        entity.id = id
        entity.amount = NSDecimalNumber(decimal: amount)
        entity.buyerId = buyer.asPerson.id
        entity.ownerId = owner.asPerson?.id
        entity.orderNumber = Int32(orderNumber)
        return entity
    }
}

extension ReceiptPositionEntity {
    func asReceiptPosition(people: People) -> ReceiptPosition? {
        guard
            let id = id,
            let amount = amount?.decimalValue,
            let buyer = getBuyer(from: people)
        else { return nil }

        let owner = getOwner(from: people)
        return .init(id: id, amount: amount, buyer: buyer, owner: owner)
    }

    private func getBuyer(from people: People) -> Buyer? {
        guard let buyerId = buyerId, let person = people.findBy(id: buyerId) else {
            return nil
        }
        return .person(person)
    }

    private func getOwner(from people: People) -> Owner {
        guard let ownerId = ownerId, let person = people.findBy(id: ownerId) else {
            return .all
        }
        return .person(person)
    }
}
