import BillsDivider_Model
import Combine
import Foundation
import SwiftUI

public final class EditOverlayViewModel: ObservableObject {
    @Published public var priceText: String
    @Published public var buyer: Buyer
    @Published public var owner: Owner
    @Published public var isPriceCorrect: Bool
    @Published public var canConfirm: Bool
    @Published public var showDiscount: Bool

    @Published public var buyers: [Buyer]
    @Published public var owners: [Owner]

    public let pricePlaceHolderText: String

    public var positionAdded: AnyPublisher<ReceiptPosition, Never>
    public var positionEdited: AnyPublisher<ReceiptPosition, Never>

    public var pageName: String {
        editOverlayStrategy.pageName
    }

    var getInitialBuyer: (() -> Buyer)?
    var getInitialOwner: (() -> Owner)?

    var addAnother: Bool

    @Binding private var presenting: Bool

    private let editOverlayStrategy: EditOverlayStrategy
    private var subscriptions: [AnyCancellable]

    public init(
        presenting: Binding<Bool>,
        editOverlayStrategy: EditOverlayStrategy,
        peopleService: PeopleService,
        numberFormatter: NumberFormatter
    ) {
        self._presenting = presenting
        self.editOverlayStrategy = editOverlayStrategy

        self.priceText = ""
        self.pricePlaceHolderText = numberFormatter.format(value: 0)
        self.buyer = .person(.empty)
        self.owner = .all
        self.addAnother = false
        self.canConfirm = false
        self.showDiscount = false
        self.isPriceCorrect = false

        self.buyers = []
        self.owners = []

        self.positionAdded = Empty<ReceiptPosition, Never>().eraseToAnyPublisher()
        self.positionEdited = Empty<ReceiptPosition, Never>().eraseToAnyPublisher()
        self.subscriptions = []

        self.editOverlayStrategy.set(viewModel: self)

        self.subscribe(to: peopleService.peopleDidUpdate)
        self.subscribe(to: $priceText.eraseToAnyPublisher())
    }

    public func confirmDidTap() {
        guard let receiptPosition = tryCreateReceiptPosition() else {
            preconditionFailure("Unable to create Receipt Position.")
        }

        addAnother ? priceText.removeAll() : dismiss()
        editOverlayStrategy.confirmDidTap(with: receiptPosition, in: self)
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

    private func subscribe(to priceText: AnyPublisher<String, Never>) {
        priceText
            .sink { [weak self] in
                guard let self = self else { return }
                let parsedPrice = self.tryParsePrice($0)
                self.isPriceCorrect = $0.isEmpty || parsedPrice != nil
                self.canConfirm = !$0.isEmpty && self.isPriceCorrect && parsedPrice! > 0
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
