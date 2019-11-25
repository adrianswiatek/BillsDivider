import Combine
import Foundation

class SummaryViewModel: ObservableObject {
    @Published private var divisionResult: BillsDivisionResult

    let leftSidedBuyer: Buyer
    let rightSidedBuyer: Buyer

    var formattedDirection: String {
        switch divisionResult {
        case .noDebt:
            return "equal"
        case .debt(let lender, _, _) where lender == leftSidedBuyer:
            return "arrow.left"
        default:
            return "arrow.right"
        }
    }

    var formattedDebt: String {
        return numberFormatter.format(value: divisionResult.debtAmount)
    }

    private let numberFormatter: NumberFormatter
    private var subscriptions: [AnyCancellable]

    init(positions: AnyPublisher<[ReceiptPosition], Never>, numberFormatter: NumberFormatter) {
        self.numberFormatter = numberFormatter
        self.subscriptions = []
        self.divisionResult = .debt(lender: .notMe, debtor: .me, amount: 24.99)
        self.leftSidedBuyer = .me
        self.rightSidedBuyer = .notMe

        self.setupSubscriptions(positions)
    }

    private func setupSubscriptions(_ positions: AnyPublisher<[ReceiptPosition], Never>) {
        positions
            .sink { print($0) }
            .store(in: &subscriptions)
    }
}
