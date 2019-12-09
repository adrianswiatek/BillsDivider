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

    private func removeExistingPositions() {
        let request: NSFetchRequest<ReceiptPositionEntity> = ReceiptPositionEntity.fetchRequest()
        let entities = try? context.fetch(request)
        entities?.forEach { context.delete($0) }
    }

    private func getMapped(_ position: ReceiptPosition) -> ReceiptPositionEntity {
        let mappedPosition = ReceiptPositionEntity(context: context)
        mappedPosition.id = position.id
        mappedPosition.amount = NSDecimalNumber(decimal: position.amount)
        mappedPosition.buyer = String(describing: position.buyer)
        mappedPosition.owner = String(describing: position.owner)
        return mappedPosition
    }

    private func save() {
        guard context.hasChanges else { return }
        try? context.save()
    }
}
