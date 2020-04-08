public final class DecimalParser {
    public enum DecimalParseError: Error {
        case wrongFormat
        case exceededMaximumValue
    }

    public init() {}

    public func parse(_ value: String) -> Result<Decimal, DecimalParseError> {
        let value = value.replacingOccurrences(of: ",", with: ".")

        if hasMoreThanTwoDigitsAfterDot(value) {
            return .failure(.wrongFormat)
        }

        if hasInvalidCharacter(value) {
            return .failure(.wrongFormat)
        }

        if hasMoreThanOneDot(value) {
            return .failure(.wrongFormat)
        }

        if hasMoreThanFiveDigitsBeforeDot(value) {
            return .failure(.exceededMaximumValue)
        }

        if let parsedValue = Decimal(string: value) {
            return .success(parsedValue)
        }

        return .failure(.wrongFormat)
    }

    public func tryParse(_ value: String) -> Decimal? {
        if case .success(let parsedValue) = parse(value) {
            return parsedValue
        }
        return nil
    }

    private func hasMoreThanTwoDigitsAfterDot(_ value: String) -> Bool {
        if let indexOfDot = value.firstIndex(of: "."), value[indexOfDot...].count > 3 {
            return true
        }
        return false
    }

    private func hasInvalidCharacter(_ value: String) -> Bool {
        for character in value {
            if character.isLetter || character.isSymbol || character == "-" {
                return true
            }
        }
        return false
    }

    private func hasMoreThanOneDot(_ value: String) -> Bool {
        if let firstIndexOfDot = value.firstIndex(of: "."), let lastIndexOfDot = value.lastIndex(of: ".") {
            return firstIndexOfDot != lastIndexOfDot
        }
        return false
    }

    private func hasMoreThanFiveDigitsBeforeDot(_ value: String) -> Bool {
        if let indexOfDot = value.firstIndex(of: ".") {
            return value[..<indexOfDot].count > 5
        }
        return value.count > 5
    }
}
