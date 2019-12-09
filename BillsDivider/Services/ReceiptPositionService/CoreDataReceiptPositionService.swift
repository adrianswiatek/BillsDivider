import CoreData

final class CoreDataReceiptPositionService: ReceiptPositionService {
    private let context: NSManagedObjectContext

    init(_ context: NSManagedObjectContext) {
        self.context = context
    }

    func set(_ positions: [ReceiptPosition]) {
        removeExistingPositions()

        positions
            .map { getMapped($0) }
            .forEach { context.insert($0) }

        save()
    }

    func fetchPositions() -> [ReceiptPosition] {
        fetchEntities().map { getMapped($0) }
    }

    private func fetchEntities() -> [ReceiptPositionEntity] {
        let request: NSFetchRequest<ReceiptPositionEntity> = ReceiptPositionEntity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }

    private func removeExistingPositions() {
        fetchEntities().forEach { context.delete($0) }
    }

    private func getMapped(_ position: ReceiptPosition) -> ReceiptPositionEntity {
        let mappedPosition = ReceiptPositionEntity(context: context)
        mappedPosition.id = position.id
        mappedPosition.amount = NSDecimalNumber(decimal: position.amount)
        mappedPosition.buyer = String(describing: position.buyer)
        mappedPosition.owner = String(describing: position.owner)
        return mappedPosition
    }

    private func getMapped(_ position: ReceiptPositionEntity) -> ReceiptPosition {
        guard
            let id = position.id,
            let amount = position.amount?.decimalValue,
            let buyer = Buyer.from(string: position.buyer ?? ""),
            let owner = Owner.from(string: position.owner ?? "")
        else { preconditionFailure("Invalid entity in Core Data.") }

        return .init(id: id, amount: amount, buyer: buyer, owner: owner)
    }

    private func save() {
        guard context.hasChanges else { return }
        try? context.save()
    }
}
