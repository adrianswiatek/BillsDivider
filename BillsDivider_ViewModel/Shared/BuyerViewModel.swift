import BillsDivider_Model
import Combine

public final class BuyerViewModel: ObservableObject {
    @Published public var buyer: Buyer
    @Published public var buyers: [Buyer]

    private var subscriptions: [AnyCancellable]

    public init(peopleService: PeopleService) {
        self.buyer = .person(.empty)
        self.buyers = []
        self.subscriptions = []
        self.subscribe(to: peopleService.peopleDidUpdate)
    }

    private func subscribe(to peopleDidUpdate: AnyPublisher<People, Never>) {
        peopleDidUpdate
            .sink { [weak self] in
                guard let self = self else { return }
                precondition($0.count >= 2, "There must be at least 2 people.")

                self.buyers = $0.map { Buyer.person($0) }
                self.buyer = self.buyers[0]
            }
            .store(in: &subscriptions)
    }
}
