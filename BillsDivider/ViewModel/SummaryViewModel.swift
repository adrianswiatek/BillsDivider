import Foundation

class SummaryViewModel: ObservableObject {
    @Published private var result: BillsDivisionResult

    let leftSidedBuyer: Buyer
    let rightSidedBuyer: Buyer

    var formattedDirection: String {
        switch result {
        case .noDebt:
            return "equal"
        case .debt(let lender, _, _) where lender == leftSidedBuyer:
            return "arrow.left"
        default:
            return "arrow.right"
        }
    }

    var formattedDebt: String {
        return numberFormatter.format(value: result.debtAmount)
    }

    private let numberFormatter: NumberFormatter

    init(numberFormatter: NumberFormatter) {
        self.numberFormatter = numberFormatter
        self.result = .debt(lender: .notMe, debtor: .me, amount: 24.99)
        self.leftSidedBuyer = .me
        self.rightSidedBuyer = .notMe
    }
}
