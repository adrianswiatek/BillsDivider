import Combine
import Foundation

class ReceiptViewModel: ObservableObject {
    @Published var positions: [ReceiptPosition2]

    private let receiptPositionService: ReceiptPositionService2
    private let numberFormatter: NumberFormatter

    private var externalSubscriptions: [AnyCancellable]
    private var internalSubscriptions: [AnyCancellable]

    init(receiptPositionService: ReceiptPositionService2, numberFormatter: NumberFormatter) {
        self.receiptPositionService = receiptPositionService
        self.numberFormatter = numberFormatter
        self.positions = []
        self.externalSubscriptions = []
        self.internalSubscriptions = []

        self.subscribe(to: receiptPositionService.positionsDidUpdate)
    }

    func subscribe(
        addingPublisher: AnyPublisher<ReceiptPosition2, Never>,
        editingPublisher: AnyPublisher<ReceiptPosition2, Never>
    ) {
        externalSubscriptions.removeAll()

        addingPublisher
            .sink { [weak self] in self?.receiptPositionService.insert($0) }
            .store(in: &externalSubscriptions)

        editingPublisher
            .sink { [weak self] in self?.receiptPositionService.update($0) }
            .store(in: &externalSubscriptions)
    }

    func removePosition(at index: Int) {
        precondition(index >= 0 && index < positions.count, "Invalid index")
        removePosition(positions[index])
    }

    func removePosition(_ position: ReceiptPosition2) {
        receiptPositionService.remove(position)
    }

    func removeAllPositions() {
        receiptPositionService.removeAllPositions()
    }

    func formatNumber(value: Decimal) -> String {
        numberFormatter.format(value: value)
    }

    private func subscribe(to receiptPositionDidUpdate: AnyPublisher<[ReceiptPosition2], Never>) {
        receiptPositionDidUpdate
            .sink { [weak self] in self?.positions = $0 }
            .store(in: &internalSubscriptions)
    }
}
