import Foundation

extension NumberFormatter {
    static var twoFracionDigitsNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }

    func format(value: Double) -> String {
        guard let result = string(for: value) else {
            preconditionFailure("Unable to format provided value.")
        }
        return result
    }
}
