import Foundation

extension NumberFormatter {
    static var twoFractionDigitsNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }

    func format(value: Decimal) -> String {
        guard let result = string(for: value) else {
            preconditionFailure("Unable to format provided value.")
        }
        return result
    }
}
