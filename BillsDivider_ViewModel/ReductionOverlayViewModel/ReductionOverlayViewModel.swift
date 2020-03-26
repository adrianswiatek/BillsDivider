import BillsDivider_Model
import Combine
import SwiftUI

public final class ReductionOverlayViewModel: ObservableObject {
    @Published public var priceViewModel: PriceViewModel
    @Published public var buyerViewModel: BuyerViewModel
    @Published public var ownerViewModel: OwnerViewModel

    @Published public var canConfirm: Bool

    @Binding private var presenting: Bool

    private let reductionAddedSubject: PassthroughSubject<ReceiptPosition, Never>
    public var reductionAdded: AnyPublisher<ReceiptPosition, Never> {
        reductionAddedSubject.eraseToAnyPublisher()
    }

    private let decimalParser: DecimalParser
    private var subscriptions: [AnyCancellable]

    public init(
        presenting: Binding<Bool>,
        priceViewModel: PriceViewModel,
        buyerViewModel: BuyerViewModel,
        ownerViewModel: OwnerViewModel,
        decimalParser: DecimalParser
    ) {
        self._presenting = presenting
        self.priceViewModel = priceViewModel
        self.buyerViewModel = buyerViewModel
        self.ownerViewModel = ownerViewModel
        self.decimalParser = decimalParser

        self.canConfirm = false
        self.reductionAddedSubject = .init()
        self.subscriptions = []

        self.subscribeToPriceViewModel()
    }

    public func dismiss() {
        presenting = false
    }

    public func confirmDidTap() {
        guard let receiptPosition = tryCreateReceiptPosition() else {
            preconditionFailure("Unable to create Receipt Position.")
        }

        reductionAddedSubject.send(receiptPosition)
        dismiss()
    }

    private func subscribeToPriceViewModel() {
        priceViewModel.$isValid
            .assign(to: \.canConfirm, on: self)
            .store(in: &subscriptions)
    }

    private func tryCreateReceiptPosition() -> ReceiptPosition? {
        guard let price = decimalParser.tryParse(priceViewModel.text) else {
            return nil
        }

        return .init(amount: price * -1, buyer: buyerViewModel.buyer, owner: ownerViewModel.owner)
    }
}
