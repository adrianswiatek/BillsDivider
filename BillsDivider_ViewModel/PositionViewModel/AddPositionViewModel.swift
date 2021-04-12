import BillsDivider_Model
import Combine

public final class AddPositionViewModel: ObservableObject {
    @Published public var price: MoneyViewModel
    @Published public var discount: MoneyViewModel
    @Published public var buyer: Buyer
    @Published public var owner: Owner

    @Published public private(set) var isConfirmationVisible: Bool
    @Published public private(set) var canAddPosition: Bool

    public private(set) var buyers: [Buyer]
    public private(set) var owners: [Owner]

    private var cancellables: Set<AnyCancellable>

    private let positionService: ReceiptPositionService
    private let peopleService: PeopleService
    private let decimalParser: DecimalParser

    public init(
        _ receiptPositionService: ReceiptPositionService,
        _ peopleService: PeopleService,
        _ decimalParser: DecimalParser
    ) {
        self.positionService = receiptPositionService
        self.peopleService = peopleService
        self.decimalParser = decimalParser

        self.price = .price(withParser: decimalParser)
        self.discount = .discount(withParser: decimalParser)
        self.buyer = .person(.empty)
        self.owner = .all

        self.isConfirmationVisible = false
        self.canAddPosition = false

        self.buyers = []
        self.owners = []

        self.cancellables = []

        self.bind()
    }

    public func initialize() {
        reset()

        guard let position = positionService.fetchPositions().first else {
            return
        }

        buyer = position.buyer
        owner = position.owner
    }

    public func addPosition() {
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

        Publishers.CombineLatest($price, $discount)
            .sink { [weak self] price, discount in
                let areValuesValid = (price.parsedValue ?? 0) < (discount.parsedValue ?? 0)
                areValuesValid ? price.state = .invalid : price.resetState()
                areValuesValid ? discount.state = .invalid : price.resetState()

                self?.canAddPosition = price.state.is(.valid) && discount.state.is(.valid, .empty)
            }
            .store(in: &cancellables)

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
        price.parsedValue.map {
            .init(amount: $0, discount: discount.parsedValue, buyer: buyer, owner: owner)
        }
    }

    private func reset() {
        price.reset()
        discount.reset()
        canAddPosition = false
    }
}
