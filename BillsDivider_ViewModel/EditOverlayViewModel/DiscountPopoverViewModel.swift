import BillsDivider_Model
import Combine

public final class DiscountPopoverViewModel: ObservableObject {
    @Published public var text: String
    @Published public private(set) var isValid: Bool

    public var valuePublisher: AnyPublisher<Decimal?, Never> {
        $text.map(decimalParser.tryParse).eraseToAnyPublisher()
    }

    public var didDismissPublisher: AnyPublisher<String, Never> {
        didDismissSubject.eraseToAnyPublisher()
    }

    private let didDismissSubject: PassthroughSubject<String, Never>
    private let decimalParser: DecimalParser
    private let numberFormatter: NumberFormatter

    private var value: Decimal?
    private var subscriptions: [AnyCancellable]

    public init(decimalParser: DecimalParser, numberFormatter: NumberFormatter) {
        self.decimalParser = decimalParser
        self.numberFormatter = numberFormatter

        self.text = ""
        self.isValid = false

        self.didDismissSubject = .init()
        self.subscriptions = []

        self.bind()
    }

    public func confirm() {
        if let value = value {
            dismissWithValue(numberFormatter.format(value: value))
        } else {
            dismissWithValue("")
        }
    }

    public func dismiss() {
        dismissWithValue("")
    }

    private func dismissWithValue(_ value: String) {
        didDismissSubject.send(value)
        text = ""
    }

    private func bind() {
        valuePublisher
            .map { $0 != nil && $0! > 0 }
            .sink { [weak self] in self?.isValid = $0 }
            .store(in: &subscriptions)

        valuePublisher
            .sink { [weak self] in self?.value = $0 }
            .store(in: &subscriptions)
    }
}
