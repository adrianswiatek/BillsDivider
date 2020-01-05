import Foundation

extension NumberFormatter {
    public static var twoFractionDigitsNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }

    public static var oridinalNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }

    public func format<T: Numeric>(value: T) -> String {
        guard let result = string(for: value) else {
            preconditionFailure("Unable to format provided value.")
        }
        return result
    }
}
