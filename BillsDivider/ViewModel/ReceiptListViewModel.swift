import Combine

class ReceiptListViewModel: ObservableObject {
    @Published var positions: [ReceiptPosition]

    private var subscriptions: [AnyCancellable]

    init() {
        self.positions = []
        self.subscriptions = []
    }

    func subscribe(to publisher: AnyPublisher<ReceiptPosition, Never>) {
        subscriptions.removeAll()

        publisher
            .sink { [weak self] in self?.positions.insert($0, at: 0) }
            .store(in: &subscriptions)
    }

    func removePosition(at index: Int) {
        precondition(index >= 0 && index < positions.count, "Invalid index")
        positions.remove(at: index)
    }

    func removeAllPositions() {
        positions.removeAll()
    }
}
