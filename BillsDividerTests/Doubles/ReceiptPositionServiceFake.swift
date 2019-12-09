@testable import BillsDivider

class ReceiptPositionServiceFake: ReceiptPositionService {
    private var positions: [ReceiptPosition] = []

    func set(_ positions: [ReceiptPosition]) {
        self.positions = positions
    }

    func fetchPositions() -> [ReceiptPosition] {
        positions
    }
}
