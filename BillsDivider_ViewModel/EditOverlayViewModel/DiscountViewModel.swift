import BillsDivider_Model
import Combine

public final class DiscountViewModel: ObservableObject {
    @Published public var text: String

    @Published public private(set) var presentingPopover: Bool

    public var hasDiscount: Bool {
        !text.isEmpty
    }

    public var valuePublisher: AnyPublisher<Decimal?, Never> {
        $text.map(decimalParser.tryParse).eraseToAnyPublisher()
    }

    private var subscriptions: [AnyCancellable]
    private let decimalParser: DecimalParser

    public init(discountPopoverViewModel: DiscountPopoverViewModel, decimalParser: DecimalParser) {
        self.decimalParser = decimalParser

        self.text = ""
        self.presentingPopover = false
        self.subscriptions = []

        self.subscribe(to: discountPopoverViewModel.didDismissPublisher)
    }

    public func showDiscountPopover() {
        presentingPopover = true
    }

    public func removeDiscount() {
        text = ""
    }

    private func subscribe(to didDismiss: AnyPublisher<String, Never>) {
        didDismiss
            .sink { [weak self] formattedDiscount in
                guard let self = self else { return }
                self.presentingPopover = false
                self.text = formattedDiscount
            }
            .store(in: &subscriptions)
    }
}
