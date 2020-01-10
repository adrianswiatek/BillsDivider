import BillsDivider_Model
import Combine
import Foundation

public class SummaryViewModel: ObservableObject {
    @Published private var divisionResult: DivisionResult

    public var leftSidedBuyer: Buyer
    public var rightSidedBuyer: Buyer

    public var formattedDirection: String {
        switch divisionResult {
        case .noDebt:
            return "equal"
        case .debt(let lender, _, _) where lender == leftSidedBuyer:
            return "arrow.left"
        default:
            return "arrow.right"
        }
    }

    public var formattedDebt: String {
        return numberFormatter.format(value: divisionResult.debtAmount)
    }

    private let receiptPositionService: ReceiptPositionService
    private let divider: PositionsDivider
    private let numberFormatter: NumberFormatter

    private var people: People
    private var subscriptions: [AnyCancellable]

    public init(
        _ receiptPositionService: ReceiptPositionService,
        _ peopleService: PeopleService,
        _ divider: PositionsDivider,
        _ numberFormatter: NumberFormatter
    ) {
        self.receiptPositionService = receiptPositionService
        self.divider = divider
        self.numberFormatter = numberFormatter

        self.people = .empty
        self.subscriptions = []

        self.divisionResult = .noDebt
        self.leftSidedBuyer = .person(.empty)
        self.rightSidedBuyer = .person(.empty)

        self.subscribe(to: receiptPositionService.positionsDidUpdate)
        self.subscribe(to: peopleService.peopleDidUpdate)
    }

    private func subscribe(to positionsDidUpdate: AnyPublisher<[ReceiptPosition], Never>) {
        positionsDidUpdate
            .sink { [weak self] in
                guard let self = self else { return }
                self.divisionResult = self.divider.divide($0, between: self.people)
            }
            .store(in: &subscriptions)
    }

    private func subscribe(to peopleDidUpdate: AnyPublisher<People, Never>) {
        peopleDidUpdate
            .sink { [weak self] in
                guard let self = self else { return }
                precondition($0.count >= 2, "There must be at least 2 people.")

                self.people = $0
                self.leftSidedBuyer = .person($0[0])
                self.rightSidedBuyer = .person($0[1])
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
    }
}
