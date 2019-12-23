import Combine
import Foundation

class SummaryViewModel: ObservableObject {
    @Published private var divisionResult: DivisionResult

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

    private let divider: Divider
    private let numberFormatter: NumberFormatter
    private var subscriptions: [AnyCancellable]

    init(
        positions: AnyPublisher<[ReceiptPosition], Never>,
        divider: Divider,
        numberFormatter: NumberFormatter,
        peopleService: PeopleService
    ) {
        self.numberFormatter = numberFormatter
        self.divider = divider
        self.subscriptions = []
        self.divisionResult = .noDebt
        self.leftSidedBuyer = .me
        self.rightSidedBuyer = .notMe

        self.setupSubscriptions(positions)
    }

    private func setupSubscriptions(_ positions: AnyPublisher<[ReceiptPosition], Never>) {
        positions
            .sink { [weak self] in self?.divisionResult = self?.divider.divide($0) ?? .noDebt }
            .store(in: &subscriptions)
    }
}
