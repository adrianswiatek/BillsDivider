import BillsDivider_Model
import Combine

public final class OwnerViewModel: ObservableObject {
    @Published public var owner: Owner
    @Published public var owners: [Owner]

    private var cancellables: Set<AnyCancellable>

    public init(_ peopleService: PeopleService) {
        self.owner = .all
        self.owners = []
        self.cancellables = []
        self.subscribe(to: peopleService.peopleDidUpdate)
    }

    private func subscribe(to peopleDidUpdate: AnyPublisher<People, Never>) {
        peopleDidUpdate
            .sink { [weak self] in
                precondition($0.count >= 2, "There must be at least 2 people.")
                self?.owners = $0.map { Owner.person($0) } + [.all]
            }
            .store(in: &cancellables)
    }
}
