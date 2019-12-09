protocol ReceiptPositionService {
    func set(_ positions: [ReceiptPosition])
    func fetchPositions() -> [ReceiptPosition]
}
