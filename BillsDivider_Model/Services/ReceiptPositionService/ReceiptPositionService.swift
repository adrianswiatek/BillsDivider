import Combine

public protocol ReceiptPositionService {
    var positionsDidUpdate: AnyPublisher<[ReceiptPosition], Never> { get }

    func insert(_ position: ReceiptPosition)
    func update(_ position: ReceiptPosition)
    func remove(_ position: ReceiptPosition)
    func removeById(_ id: UUID)
    func removeAllPositions()
    func fetchAll() -> [ReceiptPosition]
    func findById(_ id: UUID) -> ReceiptPosition?
}
