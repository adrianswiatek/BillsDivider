import BillsDivider_Model
import Combine

public final class ValueViewModel: ObservableObject {
    @Published public var text: String

    public let placeholder: String
    public var isCorrect: Bool

    public var value: AnyPublisher<Decimal?, Never> {
        $text.map(toDecimal).eraseToAnyPublisher()
    }

    private var subscriptions: [AnyCancellable]
    private let decimalParser: DecimalParser

    public init(decimalParser: DecimalParser, numberFormatter: NumberFormatter) {
        self.decimalParser = decimalParser
        self.text = ""
        self.placeholder = numberFormatter.format(value: 0)
        self.isCorrect = false
        self.subscriptions = []

        $text.combineLatest(value)
            .map { $0.isEmpty || $1 != nil }
            .assign(to: \.isCorrect, on: self)
            .store(in: &subscriptions)
    }

    private func toDecimal(_ value: String) -> Decimal? {
        if case .success(let parsedValue) = decimalParser.parse(value) {
            return parsedValue
        }
        return nil
    }
}
