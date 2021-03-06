import BillsDivider_Model
import Combine

public final class PriceViewModel: ObservableObject {
    @Published public var text: String

    @Published public private(set) var isValid: Bool
    @Published public private(set) var validationMessage: String

    public let placeholder: String

    public var valuePublisher: AnyPublisher<Decimal?, Never> {
        $text.map(decimalParser.tryParse).eraseToAnyPublisher()
    }

    private var subscriptions: [AnyCancellable]
    private let decimalParser: DecimalParser

    public init(decimalParser: DecimalParser, numberFormatter: NumberFormatter) {
        self.decimalParser = decimalParser

        self.text = ""
        self.isValid = false
        self.validationMessage = " "

        self.placeholder = numberFormatter.format(value: 0)
        self.subscriptions = []

        self.bind()
    }

    private func bind() {
        valuePublisher
            .map { $0 != nil && $0! > 0 }
            .sink { [weak self] in self?.isValid = $0 }
            .store(in: &subscriptions)

        $text
            .map { [weak self] in $0.isEmpty || self?.decimalParser.tryParse($0) != nil }
            .map { $0 ? " " : "Invalid value" }
            .sink { [weak self] in self?.validationMessage = $0 }
            .store(in: &subscriptions)
    }
}
