import BillsDivider_Model
import Combine

public final class MoneyViewModel: ObservableObject {
    @Published public var value: String
    @Published public var state: State

    public let name: String
    public let fontSize: Double

    public var parsedValue: Decimal? {
        if case .success(let value) = parser.parse(value) {
            return value
        }
        return nil
    }

    private var cancellables: Set<AnyCancellable>
    private let parser: DecimalParser

    private init(name: String, fontSize: Double, parser: DecimalParser) {
        self.name = name
        self.fontSize = fontSize
        self.parser = parser

        self.value = ""
        self.state = .empty

        self.cancellables = []

        self.bind()
    }

    public static func price(withParser parser: DecimalParser) -> MoneyViewModel {
        .init(name: "Price", fontSize: 32, parser: parser)
    }

    public static func discount(withParser parser: DecimalParser) -> MoneyViewModel {
        .init(name: "Discount", fontSize: 24, parser: parser)
    }

    public static func reduction(withParser parser: DecimalParser) -> MoneyViewModel {
        .init(name: "Reduction", fontSize: 32, parser: parser)
    }

    public func reset() {
        value = ""
    }

    public func resetState() {
        setStateForValue(value)
    }

    private func bind() {
        $value
            .sink { [weak self] in self?.setStateForValue($0) }
            .store(in: &cancellables)
    }

    private func setStateForValue(_ value: String) {
        if value == "" {
            state = .empty
        } else if case .success = parser.parse(value) {
            state = .valid
        } else {
            state = .invalid
        }
    }
}

extension MoneyViewModel {
    public enum State {
        case empty, invalid, valid

        public func `is`(_ states: State...) -> Bool {
            states.contains(self)
        }
    }
}
