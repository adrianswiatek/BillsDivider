final class InMemoryReceiptPositionService: ReceiptPositionService {
    private var positions: [ReceiptPosition] = []

    func set(_ positions: [ReceiptPosition]) {
        self.positions = positions
    }

    func fetchPositions() -> [ReceiptPosition] {
        positions
    }
}
