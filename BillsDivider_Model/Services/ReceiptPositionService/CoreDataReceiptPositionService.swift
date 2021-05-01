import Combine
import CoreData

public final class CoreDataReceiptPositionService: ReceiptPositionService {
    public var positionsDidUpdate: AnyPublisher<[ReceiptPosition], Never> {
        positionsDidUpdateSubject.eraseToAnyPublisher()
    }

    private let peopleService: PeopleService
    private let context: NSManagedObjectContext

    private let positionsDidUpdateSubject: PassthroughSubject<[ReceiptPosition], Never>
    private var subscriptions: [AnyCancellable]

    public init(_ context: NSManagedObjectContext, _ peopleService: PeopleService) {
        self.context = context
        self.peopleService = peopleService
        self.positionsDidUpdateSubject = .init()
        self.subscriptions = []

        subscribe(to: peopleService.peopleDidUpdate)
    }

    public func insert(_ position: ReceiptPosition) {
        var positions = fetchAll()
        removeAllEntities()

        positions.insert(position, at: 0)

        insert(positions)
        save()

        positionsDidUpdateSubject.send(positions)
    }

    private func insert(_ positions: [ReceiptPosition]) {
        positions
            .enumerated()
            .map { $1.asReceiptPositionEntity(orderNumber: $0, context: context) }
            .forEach { context.insert($0) }
    }

    public func update(_ position: ReceiptPosition) {
        var positions = fetchAll()
        removeAllEntities()

        guard let index = positions.firstIndex(where: { $0.id == position.id }) else {
            return
        }

        positions[index] = position

        insert(positions)
        save()

        positionsDidUpdateSubject.send(positions)
    }

    public func remove(_ position: ReceiptPosition) {
        removeById(position.id)
    }

    public func removeById(_ id: UUID) {
        var positions = fetchAll()
        removeAllEntities()

        positions.removeAll { $0.id == id }

        insert(positions)
        save()

        positionsDidUpdateSubject.send(positions)
    }

    public func removeAllPositions() {
        removeAllEntities()
        save()
        positionsDidUpdateSubject.send([])
    }

    public func fetchAll() -> [ReceiptPosition] {
        let people = peopleService.fetchPeople()
        return fetchEntities(sorted: true).compactMap { $0.asReceiptPosition(people: people) }
    }

    public func findById(_ id: UUID) -> ReceiptPosition? {
        let request: NSFetchRequest<ReceiptPositionEntity> = ReceiptPositionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        guard let positions = try? context.fetch(request), let position = positions.first else {
            return nil
        }

        let people = peopleService.fetchPeople()
        return position.asReceiptPosition(people: people)
    }

    private func fetchEntities(sorted: Bool) -> [ReceiptPositionEntity] {
        let request: NSFetchRequest<ReceiptPositionEntity> = ReceiptPositionEntity.fetchRequest()

        request.sortDescriptors = sorted
            ? [NSSortDescriptor(keyPath: \ReceiptPositionEntity.orderNumber, ascending: true)]
            : []

        return (try? context.fetch(request)) ?? []
    }

    private func removeAllEntities() {
        fetchEntities(sorted: false).forEach { context.delete($0) }
    }

    private func save() {
        guard context.hasChanges else { return }
        try? context.save()
    }

    private func subscribe(to peopleDidUpdate: AnyPublisher<People, Never>) {
        peopleDidUpdate
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.positionsDidUpdateSubject.send(self.fetchAll())
            }
            .store(in: &subscriptions)
    }
}
