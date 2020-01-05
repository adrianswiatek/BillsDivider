import Foundation

extension NumberFormatter {
    static var twoFractionDigitsNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }

    static var oridinalNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }

    func format<T: Numeric>(value: T) -> String {
        guard let result = string(for: value) else {
            preconditionFailure("Unable to format provided value.")
        }
        return result
    }
}
