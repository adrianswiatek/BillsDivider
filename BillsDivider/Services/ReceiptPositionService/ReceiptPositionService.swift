import Combine

protocol ReceiptPositionService {
    var positionsDidUpdate: AnyPublisher<[ReceiptPosition], Never> { get }

    func set(_ positions: [ReceiptPosition])
    func fetchPositions() -> [ReceiptPosition]
}
