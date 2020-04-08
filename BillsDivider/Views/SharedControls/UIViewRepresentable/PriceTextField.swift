import BillsDivider_Model
import BillsDivider_ViewModel
import SwiftUI
import UIKit

struct PriceTextField: UIViewRepresentable {
    final class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var didBecomeFirstResponder: Bool
        let decimalParser: DecimalParser

        init(_ text: Binding<String>, _ decimalParser: DecimalParser) {
            self.text = text
            self.didBecomeFirstResponder = false
            self.decimalParser = decimalParser
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text.wrappedValue = textField.text ?? ""
        }

        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            guard var text = textField.text, let range = Range<String.Index>(range, in: text) else {
                return true
            }

            text.replaceSubrange(range, with: string)
            return text.isEmpty || decimalParser.tryParse(text) != nil
        }
    }

    @Binding private var text: String

    private let accessibilityIdentifier: String
    private let decimalParser: DecimalParser
    private let numberFormatter: NumberFormatter

    init(
        text: Binding<String>,
        accessibilityIdentifier: String,
        decimalParser: DecimalParser,
        numberFormatter: NumberFormatter
    ) {
        self._text = text
        self.accessibilityIdentifier = accessibilityIdentifier
        self.decimalParser = decimalParser
        self.numberFormatter = numberFormatter
    }

    func makeCoordinator() -> PriceTextField.Coordinator {
        Coordinator($text, decimalParser)
    }

    func makeUIView(context: UIViewRepresentableContext<PriceTextField>) -> UITextField {
        let textField = UITextField()
        textField.placeholder = numberFormatter.format(value: 0)
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.font = .systemFont(ofSize: 42, weight: .semibold)
        textField.delegate = context.coordinator
        textField.accessibilityIdentifier = accessibilityIdentifier
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PriceTextField>) {
        uiView.text = text

        if !context.coordinator.didBecomeFirstResponder {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
                context.coordinator.didBecomeFirstResponder = true
            }
        }
    }
}

final class PriceTextFieldFactory {
    private let decimalParser: DecimalParser
    private let numberFormatter: NumberFormatter

    init(decimalParser: DecimalParser, numberFormatter: NumberFormatter) {
        self.decimalParser = decimalParser
        self.numberFormatter = numberFormatter
    }

    func create(text: Binding<String>, accessilibityIdentifier: String) -> PriceTextField {
        PriceTextField(
            text: text,
            accessibilityIdentifier: accessilibityIdentifier,
            decimalParser: decimalParser,
            numberFormatter: numberFormatter
        )
    }
}
