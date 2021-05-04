import BillsDivider_Model
import Combine

public final class AddReductionViewModel: ObservableObject {
    @Published public var reduction: MoneyViewModel
    @Published public var buyer: Buyer
    @Published public var owner: Owner

    @Published public private(set) var isConfirmationVisible: Bool
    @Published public private(set) var canAddReduction: Bool

    public private(set) var buyers: [Buyer]
    public private(set) var owners: [Owner]

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

        self.isConfirmationVisible = false
        self.canAddReduction = false

        self.buyers = []
        self.owners = []

        self.cancellables = []

        self.bind()
    }

    public func initialize() {
        reset()

        guard let position = positionService.fetchAll().first else {
            return
        }

        buyer = position.buyer
        owner = position.owner
    }

    public func addReduction() {
        guard let position = receiptPosition() else {
            return
        }

        positionService.insert(position)
        isConfirmationVisible = true
        reset()
    }

    private func bind() {
        $isConfirmationVisible
            .filter { $0 == true }
            .delay(for: .seconds(1), scheduler: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.isConfirmationVisible = false }
            .store(in: &cancellables)

        $reduction
            .map { $0.state.is(.valid) }
            .assign(to: &$canAddReduction)

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

    private func receiptPosition() -> ReceiptPosition? {
        reduction.parsedValue.map {
            .init(amount: -$0, discount: nil, buyer: buyer, owner: owner)
        }
    }

    private func reset() {
        reduction.reset()
        canAddReduction = false
    }
}
