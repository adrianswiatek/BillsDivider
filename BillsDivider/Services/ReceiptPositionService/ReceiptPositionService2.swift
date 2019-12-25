import Combine

protocol ReceiptPositionService2 {
    var positionsDidUpdate: AnyPublisher<[ReceiptPosition2], Never> { get }

    init(peopleService: PeopleService)

    func insert(_ position: ReceiptPosition2)
    func update(_ position: ReceiptPosition2)
    func remove(_ position: ReceiptPosition2)
    func removeAllPositions()
    func fetchPositions() -> [ReceiptPosition2]
}
