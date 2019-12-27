import Combine

protocol ReceiptPositionService {
    var positionsDidUpdate: AnyPublisher<[ReceiptPosition], Never> { get }

    func insert(_ position: ReceiptPosition)
    func update(_ position: ReceiptPosition)
    func remove(_ position: ReceiptPosition)
    func removeAllPositions()
    func fetchPositions() -> [ReceiptPosition]
}
