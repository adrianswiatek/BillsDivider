import BillsDivider_Model
import Combine
import SwiftUI

public final class DiscountPopoverViewModel: ObservableObject {
    @Published public var text: String

    @Published public private(set) var isValid: Bool
    @Published public private(set) var validationMessage: String

    public let placeholder: String

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
        self.validationMessage = ""

        self.placeholder = numberFormatter.format(value: 0)

        self.didDismissSubject = .init()
        self.subscriptions = []

        self.bind()
    }

    public func confirm() {
        if let value = value {
            dismissWithValue("- \(numberFormatter.format(value: value))")
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
            .assign(to: \.isValid, on: self)
            .store(in: &subscriptions)

        valuePublisher
            .assign(to: \.value, on: self)
            .store(in: &subscriptions)

        $text
            .map { [weak self] in $0.isEmpty || self?.decimalParser.tryParse($0) != nil }
            .map { $0 ? "" : "Invalid value" }
            .assign(to: \.validationMessage, on: self)
            .store(in: &subscriptions)
    }
}
