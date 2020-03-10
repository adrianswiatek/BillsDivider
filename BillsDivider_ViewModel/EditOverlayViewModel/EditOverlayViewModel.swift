import BillsDivider_Model
import Combine
import Foundation
import SwiftUI

public final class EditOverlayViewModel: ObservableObject {
    @Published public var discountPopoverViewModel: DiscountPopoverViewModel

    @Published public var price: PriceViewModel

    @Published public var presentingDiscountPopover: Bool
    @Published public var discount: String
    @Published public var hasDiscount: Bool

    @Published public var buyer: Buyer
    @Published public var buyers: [Buyer]

    @Published public var owner: Owner
    @Published public var owners: [Owner]

    @Published public var canConfirm: Bool

    @Binding private var presenting: Bool

    public var positionAdded: AnyPublisher<ReceiptPosition, Never>
    public var positionEdited: AnyPublisher<ReceiptPosition, Never>

    public var pageName: String {
        editOverlayStrategy.pageName
    }

    internal var getInitialBuyer: (() -> Buyer)?
    internal var getInitialOwner: (() -> Owner)?

    internal var addAnother: Bool

    private let decimalParser: DecimalParser
    private let editOverlayStrategy: EditOverlayStrategy
    private var subscriptions: [AnyCancellable]

    public init(
        presenting: Binding<Bool>,
        editOverlayStrategy: EditOverlayStrategy,
        peopleService: PeopleService,
        decimalParser: DecimalParser,
        numberFormatter: NumberFormatter
    ) {
        self._presenting = presenting
        self.presentingDiscountPopover = false
        self.editOverlayStrategy = editOverlayStrategy
        self.decimalParser = decimalParser

        self.price = PriceViewModel(decimalParser: decimalParser, numberFormatter: numberFormatter)

        self.discountPopoverViewModel = .init(decimalParser: decimalParser, numberFormatter: numberFormatter)
        self.discount = ""
        self.hasDiscount = false

        self.buyer = .person(.empty)
        self.owner = .all

        self.buyers = []
        self.owners = []

        self.addAnother = false
        self.canConfirm = false

        self.positionAdded = Empty<ReceiptPosition, Never>().eraseToAnyPublisher()
        self.positionEdited = Empty<ReceiptPosition, Never>().eraseToAnyPublisher()
        self.subscriptions = []

        self.editOverlayStrategy.set(viewModel: self)

        self.subscribe(to: peopleService.peopleDidUpdate)
        self.subscribe(to: discountPopoverViewModel.didDismissPublisher)
        self.subscribeToPrices()
    }

    public func confirmDidTap() {
        guard let receiptPosition = tryCreateReceiptPosition() else {
            preconditionFailure("Unable to create Receipt Position.")
        }

        if !addAnother { dismiss() }
        editOverlayStrategy.confirmDidTap(with: receiptPosition, in: self)
    }

    public func dismiss() {
        presenting = false
    }

    public func addDiscountButtonDidTap() {
        presentingDiscountPopover = true
    }

    public func removeDiscountButtonDidTap() {
        hasDiscount = false
    }

    private func subscribe(to peopleDidUpdate: AnyPublisher<People, Never>) {
        peopleDidUpdate
            .sink { [weak self] in
                guard let self = self else { return }
                precondition($0.count >= 2, "There must be at least 2 people.")

                self.buyers = $0.map { Buyer.person($0) }
                self.owners = $0.map { Owner.person($0) } + [.all]

                if let initialBuyer = self.getInitialBuyer?() {
                    self.buyer = initialBuyer
                }

                if let initialOwner = self.getInitialOwner?() {
                    self.owner = initialOwner
                }
            }
            .store(in: &subscriptions)
    }

    private func subscribe(to didDismiss: AnyPublisher<String, Never>) {
        didDismiss
            .sink { [weak self] formattedDiscount in
                guard let self = self else { return }
                self.presentingDiscountPopover = false
                self.hasDiscount = !formattedDiscount.isEmpty
                self.discount = formattedDiscount
            }
            .store(in: &subscriptions)
    }

    private func subscribeToPrices() {
        price.valuePublisher
            .map { price in price != nil && price! > 0 }
            .assign(to: \.canConfirm, on: self)
            .store(in: &subscriptions)
    }

    private func tryCreateReceiptPosition() -> ReceiptPosition? {
        guard let price = decimalParser.tryParse(price.text) else {
            return nil
        }

        let discount = decimalParser.tryParse(self.discount)
        return ReceiptPosition(amount: price, discount: discount, buyer: buyer, owner: owner)
    }
}
