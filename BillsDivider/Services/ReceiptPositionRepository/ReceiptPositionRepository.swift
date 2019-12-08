import CoreData

class ReceiptPositionRepository {
    private let context: NSManagedObjectContext

    init(_ context: NSManagedObjectContext) {
        self.context = context
    }

    func add(_ positions: [ReceiptPosition]) {
        positions
            .map {
                let entity = ReceiptPositionEntity(context: context)
                entity.id = $0.id
                entity.amount = NSDecimalNumber(decimal: $0.amount)
                entity.buyer = String(describing: $0.buyer)
                entity.owner = String(describing: $0.owner)
                return entity
            }
            .forEach {
                context.insert($0)
            }
    }

    func save() {

    }
}
