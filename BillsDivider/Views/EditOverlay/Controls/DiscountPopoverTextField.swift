import BillsDivider_ViewModel
import SwiftUI
import UIKit

struct DiscountPopoverTextField: UIViewRepresentable {
    internal final class Coordinator: NSObject, UITextFieldDelegate {
        private let viewModel: DiscountPopoverViewModel
        internal var didBecomeFirstResponder: Bool

        internal init(_ viewModel: DiscountPopoverViewModel) {
            self.viewModel = viewModel
            self.didBecomeFirstResponder = false
        }

        internal func textFieldDidChangeSelection(_ textField: UITextField) {
            viewModel.text = textField.text ?? ""

            textField.textColor = viewModel.isValid
                ? UIColor(named: "TextFieldForeground")
                : .secondaryLabel
        }
    }

    private let viewModel: DiscountPopoverViewModel

    init(_ viewModel: DiscountPopoverViewModel) {
        self.viewModel = viewModel
    }

    func makeCoordinator() -> DiscountPopoverTextField.Coordinator {
        Coordinator(viewModel)
    }

    func makeUIView(
        context: UIViewRepresentableContext<DiscountPopoverTextField>
    ) -> UITextField {
        let textField = UITextField()
        textField.placeholder = viewModel.placeholder
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.font = .systemFont(ofSize: 42, weight: .semibold)
        textField.delegate = context.coordinator
        textField.accessibilityIdentifier = "DiscountPopover.discountTextField"
        return textField
    }

    func updateUIView(
        _ uiView: UITextField,
        context: UIViewRepresentableContext<DiscountPopoverTextField>
    ) {
        uiView.text = viewModel.text
        uiView.becomeFirstResponder()
    }
}
