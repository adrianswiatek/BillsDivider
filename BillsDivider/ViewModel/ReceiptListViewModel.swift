import Combine
import Foundation

class ReceiptListViewModel: ObservableObject {
    @Published var positions: [ReceiptPosition] {
        didSet {
            receiptPositionService.set(positions)
        }
    }

    private let receiptPositionService: ReceiptPositionService
    private let numberFormatter: NumberFormatter

    private var subscriptions: [AnyCancellable]

    init(receiptPositionService: ReceiptPositionService, numberFormatter: NumberFormatter) {
        self.receiptPositionService = receiptPositionService
        self.numberFormatter = numberFormatter
        self.positions = receiptPositionService.fetchPositions()
        self.subscriptions = []
    }

    func subscribe(
        addingPublisher: AnyPublisher<ReceiptPosition, Never>,
        editingPublisher: AnyPublisher<ReceiptPosition, Never>
    ) {
        subscriptions.removeAll()

        addingPublisher
            .sink { [weak self] in self?.positions.insert($0, at: 0) }
            .store(in: &subscriptions)

        editingPublisher
            .sink { [weak self] position in
                guard let positionsIndex = self?.positions.firstIndex(where: { $0.id == position.id }) else {
                    preconditionFailure("Cannot find index for given position")
                }
                self?.positions[positionsIndex] = position
            }
            .store(in: &subscriptions)
    }

    func removePosition(at index: Int) {
        precondition(index >= 0 && index < positions.count, "Invalid index")
        positions.remove(at: index)
    }

    func removePosition(_ position: ReceiptPosition) {
        assert(positions.contains(position), "Positions doesn't contain given position")
        positions.removeAll { $0 == position }
    }

    func removeAllPositions() {
        positions.removeAll()
    }

    func formatNumber(value: Decimal) -> String {
        numberFormatter.format(value: value)
    }
}
