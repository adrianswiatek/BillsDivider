import Combine
import CoreData

final class CoreDataReceiptPositionService: ReceiptPositionService {
    var positionsDidUpdate: AnyPublisher<[ReceiptPosition], Never> {
        positionsDidUpdateSubject.eraseToAnyPublisher()
    }

    private let positionsDidUpdateSubject: PassthroughSubject<[ReceiptPosition], Never>
    private let context: NSManagedObjectContext
    private let mapper: ReceiptPositionMapper

    init(context: NSManagedObjectContext, mapper: ReceiptPositionMapper) {
        self.positionsDidUpdateSubject = .init()
        self.context = context
        self.mapper = mapper
    }

    func set(_ positions: [ReceiptPosition]) {
        removeExistingPositions()

        positions
            .enumerated()
            .map { self.mapper.map($1, $0, self.context) }
            .forEach { context.insert($0) }

        save()

        positionsDidUpdateSubject.send(positions)
    }

    func fetchPositions() -> [ReceiptPosition] {
        fetchEntities(sorted: true).compactMap { self.mapper.map($0) }
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
        positionsDidUpdateSubject.send([])
    }

    private func save() {
        guard context.hasChanges else { return }
        try? context.save()
    }
}
