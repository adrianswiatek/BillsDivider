import BillsDivider_Model
import Combine
import Foundation
import SwiftUI

public final class EditOverlayViewModel: ObservableObject {
    @Published public var priceText: String
    @Published public var isPriceCorrect: Bool

    @Published public var buyer: Buyer
    @Published public var owner: Owner
    @Published public var buyers: [Buyer]
    @Published public var owners: [Owner]

    @Published public var showDiscount: Bool
    @Published public var discountText: String
    @Published public var isDiscountCorrect: Bool

    @Published public var canConfirm: Bool

    @Binding private var presenting: Bool

    public let pricePlaceHolderText: String

    public var positionAdded: AnyPublisher<ReceiptPosition, Never>
    public var positionEdited: AnyPublisher<ReceiptPosition, Never>

    public var pageName: String {
        editOverlayStrategy.pageName
    }

    var getInitialBuyer: (() -> Buyer)?
    var getInitialOwner: (() -> Owner)?

    var addAnother: Bool

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
        self.isPriceCorrect = false

        self.buyer = .person(.empty)
        self.owner = .all

        self.buyers = []
        self.owners = []

        self.showDiscount = false
        self.discountText = ""
        self.isDiscountCorrect = false

        self.addAnother = false
        self.canConfirm = false

        self.pricePlaceHolderText = numberFormatter.format(value: 0)

        self.positionAdded = Empty<ReceiptPosition, Never>().eraseToAnyPublisher()
        self.positionEdited = Empty<ReceiptPosition, Never>().eraseToAnyPublisher()
        self.subscriptions = []

        self.editOverlayStrategy.set(viewModel: self)

        self.subscribeToPeopleDidUpdate(peopleService.peopleDidUpdate)
        self.subscribeToPriceText($priceText.eraseToAnyPublisher())
        self.subscribeToDiscountText($discountText.eraseToAnyPublisher())
        self.subscribeToShowDiscount($showDiscount.eraseToAnyPublisher())
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

    private func subscribeToPeopleDidUpdate(_ peopleDidUpdate: AnyPublisher<People, Never>) {
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

    private func subscribeToPriceText(_ priceText: AnyPublisher<String, Never>) {
        priceText
            .sink { [weak self] in
                guard let self = self else { return }
                self.isPriceCorrect = $0.isEmpty || self.tryParsePrice($0) != nil
                self.canConfirm = self.validateIfCanConfirm()
            }
            .store(in: &subscriptions)
    }

    private func subscribeToDiscountText(_ discountText: AnyPublisher<String, Never>) {
        discountText
            .sink { [weak self] in
                guard let self = self else { return }
                self.isDiscountCorrect = $0.isEmpty || self.tryParsePrice($0) != nil
                self.canConfirm = self.validateIfCanConfirm()
            }
        .store(in: &subscriptions)
    }

    private func subscribeToShowDiscount(_ showDiscount: AnyPublisher<Bool, Never>) {
        showDiscount
            .sink { [weak self] isDiscountShown in
                guard let self = self else { return }
                self.discountText = isDiscountShown ? "" : self.discountText
            }
            .store(in: &subscriptions)
    }

    private func validateIfCanConfirm() -> Bool {
        guard let parsedPrice = tryParsePrice(priceText) else { return false }

        let priceValidationResult =
            isPriceCorrect && !priceText.isEmpty && parsedPrice > 0

        if !showDiscount {
            return priceValidationResult
        }

        guard let parsedDiscount = tryParsePrice(discountText) else { return false }

        let discountValidationResult =
            parsedDiscount <= parsedPrice && isDiscountCorrect && !discountText.isEmpty && parsedDiscount > 0

        return priceValidationResult && discountValidationResult
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
