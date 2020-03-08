import BillsDivider_Model
import Combine
import Foundation
import SwiftUI

public final class EditOverlayViewModel: ObservableObject {
    @Published public var price: ValueViewModel
    @Published public var discount: ValueViewModel

    @Published public var showDiscount: Bool
    @Published public var canConfirm: Bool

    @Published public var buyer: Buyer
    @Published public var buyers: [Buyer]

    @Published public var owner: Owner
    @Published public var owners: [Owner]

    @Binding private var presenting: Bool

    public var keyboardHeight: CGFloat

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
        self.editOverlayStrategy = editOverlayStrategy
        self.decimalParser = decimalParser

        self.price = ValueViewModel(decimalParser: decimalParser, numberFormatter: numberFormatter)
        self.discount = ValueViewModel(decimalParser: decimalParser, numberFormatter: numberFormatter)

        self.buyer = .person(.empty)
        self.owner = .all

        self.buyers = []
        self.owners = []

        self.showDiscount = false
        self.addAnother = false
        self.canConfirm = false

        self.keyboardHeight = 0

        self.positionAdded = Empty<ReceiptPosition, Never>().eraseToAnyPublisher()
        self.positionEdited = Empty<ReceiptPosition, Never>().eraseToAnyPublisher()
        self.subscriptions = []

        self.editOverlayStrategy.set(viewModel: self)

        self.observeKeyboard()
        self.subscribe(to: peopleService.peopleDidUpdate)
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

    private func observeKeyboard() {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardDidShowNotification)
            .map { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0?.height ?? 0 }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &subscriptions)

        NotificationCenter.default
            .publisher(for: UIResponder.keyboardDidHideNotification)
            .map { _ in 0 }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &subscriptions)
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

    private func subscribeToPrices() {
        Publishers.CombineLatest3(price.value, discount.value, $showDiscount)
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
            return ReceiptPosition(amount: price, discount: discountValue(), buyer: buyer, owner: owner)
        }
        return nil
    }

    private func discountValue() -> Decimal? {
        if showDiscount, case .success(let discount) = decimalParser.parse(discount.text) {
            return discount
        }
        return nil
    }
}
