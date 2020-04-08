import BillsDivider_Model
import Combine

public final class PriceViewModel: ObservableObject {
    @Published public var text: String
    @Published public private(set) var isValid: Bool

    public let placeholder: String

    public var valuePublisher: AnyPublisher<Decimal?, Never> {
        $text.map(decimalParser.tryParse).eraseToAnyPublisher()
    }

    private let decimalParser: DecimalParser
    private var subscriptions: [AnyCancellable]

    public init(decimalParser: DecimalParser, numberFormatter: NumberFormatter) {
        self.decimalParser = decimalParser

        self.text = ""
        self.isValid = false

        self.placeholder = numberFormatter.format(value: 0)
        self.subscriptions = []

        self.bind()
    }

    private func bind() {
        valuePublisher
            .map { $0 != nil }
            .sink { [weak self] in self?.isValid = $0 }
            .store(in: &subscriptions)
    }
}
