import BillsDivider_ViewModel
import SwiftUI
import UIKit

struct FirstResponderTextField: UIViewRepresentable {
    final class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var didBecomeFirstResponder: Bool

        init(_ text: Binding<String>) {
            self.text = text
            self.didBecomeFirstResponder = false
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text.wrappedValue = textField.text ?? ""
        }
    }

    @Binding private var text: String

    private let isValid: Bool
    private let placeholder: String

    init(text: Binding<String>, isValid: Bool, placeholder: String) {
        self._text = text
        self.isValid = isValid
        self.placeholder = placeholder
    }

    func makeCoordinator() -> FirstResponderTextField.Coordinator {
        Coordinator($text)
    }

    func makeUIView(context: UIViewRepresentableContext<FirstResponderTextField>) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.font = .systemFont(ofSize: 42, weight: .semibold)
        textField.delegate = context.coordinator
        textField.accessibilityIdentifier = "DiscountPopover.discountTextField"
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<FirstResponderTextField>) {
        uiView.text = text
        uiView.textColor = isValid ? UIColor(named: "TextFieldForeground") : .secondaryLabel

        if !context.coordinator.didBecomeFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}
