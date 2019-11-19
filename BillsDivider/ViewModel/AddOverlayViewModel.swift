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
        self.subscriptions = []

        self.setupSubscriptions()
    }

    func confirmDidTap() {
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
}
