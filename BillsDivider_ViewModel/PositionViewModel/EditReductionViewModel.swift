import BillsDivider_Model
import Combine

public final class EditReductionViewModel: ObservableObject {
    @Published public var reduction: MoneyViewModel
    @Published public var buyer: Buyer
    @Published public var owner: Owner

    @Published public private(set) var canUpdateReduction: Bool

    public private(set) var buyers: [Buyer]
    public private(set) var owners: [Owner]

    private var id: UUID?
    private var cancellables: Set<AnyCancellable>

    private let positionService: ReceiptPositionService
    private let peopleService: PeopleService
    private let numberFormatter: NumberFormatter

    public init(
        _ receiptPositionService: ReceiptPositionService,
        _ peopleService: PeopleService,
        _ decimalParser: DecimalParser,
        _ numberFormatter: NumberFormatter
    ) {
        self.positionService = receiptPositionService
        self.peopleService = peopleService
        self.numberFormatter = numberFormatter

        self.reduction = .reduction(withParser: decimalParser)
        self.buyer = .person(.empty)
        self.owner = .all

        self.canUpdateReduction = false

        self.buyers = []
        self.owners = []

        self.cancellables = []

        self.bind()
    }

    public func initializeWithPositionId(_ id: UUID) {
        guard let position = positionService.findById(id) else {
            return
        }

        self.id = id
        self.reduction.value = numberFormatter.format(value: -position.amount)
        self.buyer = position.buyer
        self.owner = position.owner
        self.canUpdateReduction = false
    }

    public func updateReduction() {
        guard let id = id, let reduction = reduction.parsedValue else {
            return
        }

        positionService.update(
            ReceiptPosition(id: id, amount: -reduction, buyer: buyer, owner: owner)
        )
    }

    private func bind() {
        Publishers.CombineLatest3($reduction, $buyer, $owner)
            .map { reduction, _, _ in reduction.state.is(.valid) }
            .assign(to: &$canUpdateReduction)

        peopleService.peopleDidUpdate
            .sink { [weak self] in
                guard let self = self else { return }
                precondition($0.count >= 2, "There must be at least 2 people.")

                self.buyers = $0.map { Buyer.person($0) }
                self.buyer = self.buyers[0]

                self.owners = $0.map { Owner.person($0) } + [.all]
            }
            .store(in: &cancellables)
    }
}
