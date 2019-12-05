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

    private let billsDivider: BillsDivider
    private let numberFormatter: NumberFormatter
    private var subscriptions: [AnyCancellable]

    init(
        positions: AnyPublisher<[ReceiptPosition], Never>,
        billsDivider: BillsDivider,
        numberFormatter: NumberFormatter
    ) {
        self.numberFormatter = numberFormatter
        self.billsDivider = billsDivider
        self.subscriptions = []
        self.divisionResult = .noDebt
        self.leftSidedBuyer = .me
        self.rightSidedBuyer = .notMe

        self.setupSubscriptions(positions)
    }

    private func setupSubscriptions(_ positions: AnyPublisher<[ReceiptPosition], Never>) {
        positions
            .sink { [weak self] in self?.divisionResult = self?.billsDivider.divide($0) ?? .noDebt }
            .store(in: &subscriptions)
    }
}
