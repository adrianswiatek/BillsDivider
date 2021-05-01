import BillsDivider_Model
import Combine

public final class EditPositionViewModel: ObservableObject {
    @Published public var price: MoneyViewModel
    @Published public var discount: MoneyViewModel
    @Published public var buyer: Buyer
    @Published public var owner: Owner

    @Published public private(set) var canUpdatePosition: Bool

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

        self.price = .price(withParser: decimalParser)
        self.discount = .discount(withParser: decimalParser)
        self.buyer = .person(.empty)
        self.owner = .all

        self.canUpdatePosition = false

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
        self.price.value = numberFormatter.format(value: position.amount)
        self.discount.value = position.discount.map { numberFormatter.format(value: $0) } ?? ""
        self.buyer = position.buyer
        self.owner = position.owner
        self.canUpdatePosition = false
    }

    public func updatePosition() {
        guard let id = id, let price = price.parsedValue else {
            return
        }

        positionService.update(
            ReceiptPosition(id: id, amount: price, discount: discount.parsedValue, buyer: buyer, owner: owner)
        )
    }

    private func bind() {
        Publishers.CombineLatest4($price, $discount, $buyer, $owner)
            .sink { [weak self] price, discount, _, _ in
                let areValuesInvalid = (price.parsedValue ?? 0) < (discount.parsedValue ?? 0)
                areValuesInvalid ? price.state = .invalid : price.resetState()
                areValuesInvalid ? discount.state = .invalid : discount.resetState()

                self?.canUpdatePosition = price.state.is(.valid) && discount.state.is(.valid, .empty)
            }
            .store(in: &cancellables)

        peopleService.peopleDidUpdate
            .sink { [weak self] in
                guard let self = self else { return }
                precondition($0.count >= 2, "There must be at least 2 people.")
                self.buyers = $0.map { Buyer.person($0) }
                self.owners = $0.map { Owner.person($0) } + [.all]
            }
            .store(in: &cancellables)
    }
}
