import BillsDivider_Model
import Combine
import Foundation
import SwiftUI

public final class EditOverlayViewModel: ObservableObject {
    @Published public var price: ValueViewModel
    @Published public var discountPopoverViewModel: DiscountPopoverViewModel

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

        self.price = ValueViewModel(decimalParser: decimalParser, numberFormatter: numberFormatter)

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

    public func discountButtonDidTap() {
        presentingDiscountPopover = true
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
        Publishers.CombineLatest3(price.value, discountPopoverViewModel.valuePublisher, $hasDiscount)
            .map { price, discount, showDiscount in
                guard let price = price, price > 0 else { return false }
                guard showDiscount else { return true }
                guard let discount = discount else { return false}
                return discount > 0 && discount <= price
            }
            .assign(to: \.canConfirm, on: self)
            .store(in: &subscriptions)
    }

    private func tryCreateReceiptPosition() -> ReceiptPosition? {
        if case .success(let price) = decimalParser.parse(price.text) {
            return ReceiptPosition(
                amount: price,
                discount: decimalParser.tryParse(discountPopoverViewModel.text),
                buyer: buyer,
                owner: owner
            )
        }
        return nil
    }
}
