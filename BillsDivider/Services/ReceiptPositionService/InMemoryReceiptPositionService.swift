import Combine

final class InMemoryReceiptPositionService: ReceiptPositionService {
    private let positionsDidUpdateSubject: CurrentValueSubject<[ReceiptPosition], Never>
    var positionsDidUpdate: AnyPublisher<[ReceiptPosition], Never> {
        positionsDidUpdateSubject.eraseToAnyPublisher()
    }

    private var positions: [ReceiptPosition]

    init() {
        positions = [
            .init(amount: 1, buyer: .me, owner: .notMe),
            .init(amount: 2, buyer: .me, owner: .all)
        ]
        positionsDidUpdateSubject = .init(positions)
    }

    func set(_ positions: [ReceiptPosition]) {
        self.positions = positions
        self.positionsDidUpdateSubject.send(positions)
    }

    func fetchPositions() -> [ReceiptPosition] {
        positions
    }
}
