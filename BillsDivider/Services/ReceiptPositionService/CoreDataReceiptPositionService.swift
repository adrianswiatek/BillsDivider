import CoreData

final class CoreDataReceiptPositionService: ReceiptPositionService {
    private let context: NSManagedObjectContext

    init(_ context: NSManagedObjectContext) {
        self.context = context
    }

    func set(_ positions: [ReceiptPosition]) {
        removeExistingPositions()

        positions
            .enumerated()
            .map { ReceiptPositionMapper.map($1, $0, self.context) }
            .forEach { context.insert($0) }

        save()
    }

    func fetchPositions() -> [ReceiptPosition] {
        fetchEntities(sorted: true).compactMap { ReceiptPositionMapper.map($0) }
    }

    private func fetchEntities(sorted: Bool) -> [ReceiptPositionEntity] {
        let request: NSFetchRequest<ReceiptPositionEntity> = ReceiptPositionEntity.fetchRequest()

        request.sortDescriptors = sorted
            ? [NSSortDescriptor(keyPath: \ReceiptPositionEntity.orderNumber, ascending: true)]
            : []

        return (try? context.fetch(request)) ?? []
    }

    private func removeExistingPositions() {
        fetchEntities(sorted: false).forEach { context.delete($0) }
    }

    private func save() {
        guard context.hasChanges else { return }
        try? context.save()
    }
}
