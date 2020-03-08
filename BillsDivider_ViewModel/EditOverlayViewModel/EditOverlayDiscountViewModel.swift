import BillsDivider_Model
import Combine
import SwiftUI

public final class EditOverlayDiscountViewModel: ObservableObject {
    @Published public var text: String

    public let placeholder: String
    public var isCorrect: Bool

    public var value: AnyPublisher<Decimal?, Never> {
        $text.map(decimalParser.tryParse).eraseToAnyPublisher()
    }

    public var didDismiss: AnyPublisher<Decimal?, Never> {
        didDismissSubject.eraseToAnyPublisher()
    }

    private let didDismissSubject: PassthroughSubject<Decimal?, Never>
    private let decimalParser: DecimalParser
    private var subscriptions: [AnyCancellable]

    public init(decimalParser: DecimalParser, numberFormatter: NumberFormatter) {
        self.decimalParser = decimalParser
        self.text = ""
        self.placeholder = numberFormatter.format(value: 0)
        self.isCorrect = false
        self.didDismissSubject = .init()
        self.subscriptions = []

        self.value
            .map { $0 != nil && $0! > 0 }
            .assign(to: \.isCorrect, on: self)
            .store(in: &subscriptions)
    }

    public func confirm() {
        didDismissSubject.send(nil)
    }

    public func dismiss() {
        didDismissSubject.send(nil)
    }
}
