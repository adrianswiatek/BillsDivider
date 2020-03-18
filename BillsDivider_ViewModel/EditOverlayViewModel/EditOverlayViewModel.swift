import BillsDivider_Model
import Combine
import Foundation
import SwiftUI

public final class EditOverlayViewModel: ObservableObject {
    @Published public var priceViewModel: PriceViewModel
    @Published public var discountViewModel: DiscountViewModel
    @Published public var discountPopoverViewModel: DiscountPopoverViewModel

    @Published public var buyer: Buyer
    @Published public var buyers: [Buyer]

    @Published public var owner: Owner
    @Published public var owners: [Owner]

    @Published public var canConfirm: Bool
    @Published public var confirmValidationMessage: String

    @Published public var keyboardHeight: CGFloat

    @Binding private var presenting: Bool

    public var positionAdded: AnyPublisher<ReceiptPosition, Never>
    public var positionEdited: AnyPublisher<ReceiptPosition, Never>

    public var pageName: String {
        editOverlayState.pageName
    }

    internal var getInitialBuyer: (() -> Buyer)?
    internal var getInitialOwner: (() -> Owner)?

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
        peopleService: PeopleService,
        decimalParser: DecimalParser
    ) {
        self._presenting = presenting
        self.editOverlayState = editOverlayState
        self.priceViewModel = priceViewModel
        self.discountViewModel = discountViewModel
        self.discountPopoverViewModel = discountPopoverViewModel
        self.decimalParser = decimalParser

        self.buyer = .person(.empty)
        self.owner = .all

        self.buyers = []
        self.owners = []

        self.addAnother = false
        self.canConfirm = false
        self.confirmValidationMessage = ""

        self.positionAdded = Empty<ReceiptPosition, Never>().eraseToAnyPublisher()
        self.positionEdited = Empty<ReceiptPosition, Never>().eraseToAnyPublisher()

        self.keyboardHeight = 0

        self.subscriptions = []

        self.editOverlayState.set(viewModel: self)

        self.subscribe(to: peopleService.peopleDidUpdate)
        self.subscribe(to: discountViewModel.$presentingPopover.eraseToAnyPublisher())
        self.subscribeToPrices()
        self.subscribeToKeyboard()
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

        let discount = decimalParser.tryParse(self.discountViewModel.text)
        return ReceiptPosition(amount: price, discount: discount, buyer: buyer, owner: owner)
    }

    private func subscribeToKeyboard() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)
            .sink { [weak self] in
                let keyboardRect = $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                self?.keyboardHeight = keyboardRect?.height ?? 0
            }
            .store(in: &subscriptions)

        NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)
            .sink { [weak self] _ in self?.keyboardHeight = 0 }
            .store(in: &subscriptions)
    }
}
