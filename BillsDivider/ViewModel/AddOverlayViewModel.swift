import Combine
import SwiftUI

class AddOverlayViewModel: ObservableObject {
    @Binding private var presenting: Bool

    @Published var priceText: String
    @Published var buyer: Buyer
    @Published var owner: Owner
    @Published var addAnother: Bool
    @Published var isPriceCorrect: Bool
    @Published var canConfirm: Bool

    var positionAdded: AnyPublisher<ReceiptPosition, Never> {
        positionAddedSubject.eraseToAnyPublisher()
    }

    private let positionAddedSubject: PassthroughSubject<ReceiptPosition, Never>
    private var subscriptions: [AnyCancellable]

    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    init(_ presenting: Binding<Bool>) {
        self._presenting = presenting

        self.priceText = ""
        self.buyer = .me
        self.owner = .all
        self.addAnother = true
        self.canConfirm = false
        self.isPriceCorrect = false
        self.positionAddedSubject = PassthroughSubject<ReceiptPosition, Never>()
        self.subscriptions = []

        self.setupSubscriptions()
    }

    func confirmDidTap() {
        guard let receiptPosition = tryCreateReceiptPosition() else {
            assertionFailure("Unable to create Receipt Position.")
            return
        }

        positionAddedSubject.send(receiptPosition)
        addAnother ? priceText.removeAll() : dismiss()
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

    private func tryParsePrice(_ priceText: String) -> Double? {
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

        guard
            let parsedPrice = Double(priceText),
            let formattedPrice = currencyFormatter.string(for: parsedPrice)
        else { return nil }

        return Double(formattedPrice)
    }

    private func tryCreateReceiptPosition() -> ReceiptPosition? {
        guard let price = tryParsePrice(priceText) else {
            return nil
        }

        return ReceiptPosition(amount: price, buyer: buyer, owner: owner)
    }
}
