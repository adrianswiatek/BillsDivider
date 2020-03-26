import BillsDivider_Model
import Combine
import Foundation
import SwiftUI

public final class EditOverlayViewModel: ObservableObject {
    @Published public var priceViewModel: PriceViewModel
    @Published public var discountViewModel: DiscountViewModel
    @Published public var discountPopoverViewModel: DiscountPopoverViewModel

    @Published public var buyerViewModel: BuyerViewModel
    @Published public var ownerViewModel: OwnerViewModel

    @Published public var canConfirm: Bool
    @Published public var confirmValidationMessage: String

    @Binding private var presenting: Bool

    public var positionAdded: AnyPublisher<ReceiptPosition, Never>
    public var positionEdited: AnyPublisher<ReceiptPosition, Never>

    public var pageName: String {
        editOverlayState.pageName
    }

    internal var addAnother: Bool

    private let decimalParser: DecimalParser
    private let editOverlayState: EditOverlayState
    private var subscriptions: [AnyCancellable]

    public init(
        presenting: Binding<Bool>,
        priceViewModel: PriceViewModel,
        discountViewModel: DiscountViewModel,
        discountPopoverViewModel: DiscountPopoverViewModel,
        editOverlayState: EditOverlayState,
        buyerViewModel: BuyerViewModel,
        ownerViewModel: OwnerViewModel,
        decimalParser: DecimalParser
    ) {
        self._presenting = presenting
        self.editOverlayState = editOverlayState
        self.priceViewModel = priceViewModel
        self.discountViewModel = discountViewModel
        self.discountPopoverViewModel = discountPopoverViewModel
        self.decimalParser = decimalParser

        self.buyerViewModel = buyerViewModel
        self.ownerViewModel = ownerViewModel

        self.addAnother = false
        self.canConfirm = false
        self.confirmValidationMessage = ""

        self.positionAdded = Empty<ReceiptPosition, Never>().eraseToAnyPublisher()
        self.positionEdited = Empty<ReceiptPosition, Never>().eraseToAnyPublisher()

        self.subscriptions = []

        self.editOverlayState.set(viewModel: self)

        self.subscribe(to: discountViewModel.$presentingPopover.eraseToAnyPublisher())
        self.subscribeToPrices()
    }

    public func confirmDidTap() {
        guard let receiptPosition = tryCreateReceiptPosition() else {
            preconditionFailure("Unable to create Receipt Position.")
        }

        if !addAnother { dismiss() }
        editOverlayState.confirmDidTap(with: receiptPosition, in: self)
    }

    public func dismiss() {
        presenting = false
    }

    internal func set(buyer: Buyer, owner: Owner) {
        buyerViewModel.buyer = buyer
        ownerViewModel.owner = owner
    }

    private func subscribe(to presentingDiscountPopover: AnyPublisher<Bool, Never>) {
        presentingDiscountPopover
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &subscriptions)
    }

    private func subscribeToPrices() {
        Publishers.CombineLatest(priceViewModel.valuePublisher, discountViewModel.valuePublisher)
            .map { price, discount in
                guard let price = price, price > 0 else { return false }
                guard let discount = discount else { return true }
                return price >= discount
            }
            .assign(to: \.canConfirm, on: self)
            .store(in: &subscriptions)

        Publishers.CombineLatest(priceViewModel.valuePublisher, discountViewModel.valuePublisher)
            .map { price, discount in
                guard let price = price, let discount = discount else { return "" }
                return price >= discount ? "" : "Discount is greater than Price"
            }
            .assign(to: \.confirmValidationMessage, on: self)
            .store(in: &subscriptions)
    }

    private func tryCreateReceiptPosition() -> ReceiptPosition? {
        guard let price = decimalParser.tryParse(priceViewModel.text) else {
            return nil
        }

        return ReceiptPosition(
            amount: price,
            discount: decimalParser.tryParse(discountViewModel.text),
            buyer: buyerViewModel.buyer,
            owner: ownerViewModel.owner
        )
    }
}
