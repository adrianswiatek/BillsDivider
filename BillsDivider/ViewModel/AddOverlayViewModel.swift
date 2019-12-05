import Combine
import Foundation
import SwiftUI

class AddOverlayViewModel: ObservableObject {
    @Binding private var presenting: Bool

    @Published var priceText: String
    @Published var buyer: Buyer
    @Published var owner: Owner
    @Published var addAnother: Bool
    @Published var isPriceCorrect: Bool
    @Published var canConfirm: Bool

    var pricePlaceHolderText: String {
        return NumberFormatter.twoFracionDigitsNumberFormatter.string(from: 0)!
    }

    var positionAdded: AnyPublisher<ReceiptPosition, Never> {
        positionAddedSubject.eraseToAnyPublisher()
    }

    private let positionAddedSubject: PassthroughSubject<ReceiptPosition, Never>
    private var subscriptions: [AnyCancellable]

    init(
        presenting: Binding<Bool>,
        buyer: Buyer,
        owner: Owner,
        numberFormatter: NumberFormatter
    ) {
        self._presenting = presenting

        self.priceText = ""
        self.buyer = buyer
        self.owner = owner
        self.addAnother = true
        self.canConfirm = false
        self.isPriceCorrect = false
        self.positionAddedSubject = PassthroughSubject<ReceiptPosition, Never>()
        self.subscriptions = []

        self.setupSubscriptions()
    }

    func confirmDidTap() {
        guard let receiptPosition = tryCreateReceiptPosition() else {
            preconditionFailure("Unable to create Receipt Position.")
        }

        addAnother ? priceText.removeAll() : dismiss()
        positionAddedSubject.send(receiptPosition)
    }

    func dismiss() {
        presenting = false
    }

    private func setupSubscriptions() {
        $priceText
            .sink {
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

        var priceText = priceText
        priceText = priceText.replacingOccurrences(of: ",", with: ".")

        if hasMoreThanTwoDigitsAfterDot(priceText) {
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
