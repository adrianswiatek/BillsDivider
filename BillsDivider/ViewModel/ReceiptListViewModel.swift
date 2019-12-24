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

    private var positionSubscriptions: [AnyCancellable]
    private var peopleSubscriptions: [AnyCancellable]

    init(
        receiptPositionService: ReceiptPositionService,
        peopleService: PeopleService,
        numberFormatter: NumberFormatter
    ) {
        self.receiptPositionService = receiptPositionService
        self.numberFormatter = numberFormatter
        self.positions = receiptPositionService.fetchPositions()
        self.positionSubscriptions = []
        self.peopleSubscriptions = []

        self.subscribe(to: peopleService.peopleDidUpdate)
    }

    func subscribe(
        addingPublisher: AnyPublisher<ReceiptPosition, Never>,
        editingPublisher: AnyPublisher<ReceiptPosition, Never>
    ) {
        positionSubscriptions.removeAll()

        addingPublisher
            .sink { [weak self] in self?.positions.insert($0, at: 0) }
            .store(in: &positionSubscriptions)

        editingPublisher
            .sink { [weak self] position in
                guard let positionsIndex = self?.positions.firstIndex(where: { $0.id == position.id }) else {
                    preconditionFailure("Cannot find index for given position")
                }
                self?.positions[positionsIndex] = position
            }
            .store(in: &positionSubscriptions)
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

    private func subscribe(to peopleDidUpdate: AnyPublisher<[Person], Never>) {
        peopleDidUpdate
            .sink { _ in  }
            .store(in: &peopleSubscriptions)
    }
}
