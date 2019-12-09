@testable import BillsDivider

class ReceiptPositionServiceDummy: ReceiptPositionService {
    func set(_ positions: [ReceiptPosition]) {
        // Do nothing
    }

    func fetchPositions() -> [ReceiptPosition] {
        return []
    }
}
