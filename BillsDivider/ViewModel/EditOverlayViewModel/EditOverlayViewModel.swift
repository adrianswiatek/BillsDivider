import Combine
import Foundation
import SwiftUI

final class EditOverlayViewModel: ObservableObject {
    @Binding private var presenting: Bool

    @Published var priceText: String
    @Published var buyer: Buyer
    @Published var owner: Owner
    @Published var addAnother: Bool
    @Published var isPriceCorrect: Bool
    @Published var canConfirm: Bool

    let pricePlaceHolderText: String

    var positionAdded: AnyPublisher<ReceiptPosition, Never>
    var positionEdited: AnyPublisher<ReceiptPosition, Never>

    var showAddAnother: Bool {
        editOverlayStrategy.showAddAnother
    }

    var pageName: String {
        editOverlayStrategy.pageName
    }

    private let editOverlayStrategy: EditOverlayStrategy
    private var subscriptions: [AnyCancellable]

    init(
        presenting: Binding<Bool>,
        editOverlayStrategy: EditOverlayStrategy,
        numberFormatter: NumberFormatter
    ) {
        self._presenting = presenting
        self.editOverlayStrategy = editOverlayStrategy

        self.priceText = ""
        self.pricePlaceHolderText = numberFormatter.format(value: 0)
        self.buyer = .me
        self.owner = .notMe
        self.addAnother = false
        self.canConfirm = false
        self.isPriceCorrect = false
        self.positionAdded = Empty<ReceiptPosition, Never>().eraseToAnyPublisher()
        self.positionEdited = Empty<ReceiptPosition, Never>().eraseToAnyPublisher()
        self.subscriptions = []

        self.setupSubscriptions()
        self.editOverlayStrategy.set(viewModel: self)
    }

    deinit {
        print("EditOverlayViewModel has been deinitialized.")
    }

    func confirmDidTap() {
        guard let receiptPosition = tryCreateReceiptPosition() else {
            preconditionFailure("Unable to create Receipt Position.")
        }

        addAnother ? priceText.removeAll() : dismiss()
        editOverlayStrategy.confirmDidTap(with: receiptPosition, in: self)
    }

    func dismiss() {
        presenting = false
    }

    private func setupSubscriptions() {
        $priceText
            .sink { [weak self] in
                guard let self = self else { return }
                self.isPriceCorrect = $0.isEmpty || self.tryParsePrice($0) != nil
                self.canConfirm = !$0.isEmpty && self.isPriceCorrect
            }
            .store(in: &subscriptions)
    }

    private func tryParsePrice(_ priceText: String) -> Decimal? {
        func hasMoreThanTwoDigitsAfterDot(_ priceText: String) -> Bool {
            if let indexOfDot = priceText.firstIndex(of: "."), priceText[indexOfDot...].count > 3 {
                return true
            }
            return false
        }

        func hasMoreThanFiveDigitsBeforeDot(_ priceText: String) -> Bool {
            if let indexOfDot = priceText.firstIndex(of: ".") {
                return priceText[..<indexOfDot].count > 5
            }
            return priceText.count > 5
        }

        var priceText = priceText
        priceText = priceText.replacingOccurrences(of: ",", with: ".")

        if hasMoreThanTwoDigitsAfterDot(priceText) || hasMoreThanFiveDigitsBeforeDot(priceText) {
            return nil
        }

        return Decimal(string: priceText)
    }

    private func tryCreateReceiptPosition() -> ReceiptPosition? {
        guard let price = tryParsePrice(priceText) else {
            return nil
        }

        return ReceiptPosition(amount: price, buyer: buyer, owner: owner)
    }
}
