import Combine
import SwiftUI

class AddOverlayViewModel: ObservableObject {
    @Binding private var presenting: Bool

    @Published var priceText: String
    @Published var buyer: Buyer
    @Published var owner: Owner
    @Published var addAnother: Bool

    var canConfirm: Bool {
        !priceText.isEmpty
    }

    init(_ presenting: Binding<Bool>) {
        self._presenting = presenting

        self.priceText = ""
        self.buyer = .me
        self.owner = .all
        self.addAnother = true
    }

    func confirmDidTap() {
        addAnother ? priceText.removeAll() : dismiss()
    }

    func dismiss() {
        presenting = false
    }
}
