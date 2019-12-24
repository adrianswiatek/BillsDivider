import Combine
import Foundation

class SummaryViewModel: ObservableObject {
    @Published private var divisionResult: DivisionResult

    private var leftSidedBuyer: Person
    private var rightSidedBuyer: Person

    var formattedLeftSidedBuyer: String {
        leftSidedBuyer.name
    }

    var formattedRightSidedBuyer: String {
        rightSidedBuyer.name
    }

    var formattedDirection: String {
        switch divisionResult {
        case .noDebt:
            return "equal"
        case .debt(let lender, _, _) where lender == .me:
            return "arrow.left"
        default:
            return "arrow.right"
        }
    }

    var formattedDebt: String {
        return numberFormatter.format(value: divisionResult.debtAmount)
    }

    private let peopleService: PeopleService
    private let divider: Divider
    private let numberFormatter: NumberFormatter
    private var subscriptions: [AnyCancellable]

    init(
        positions: AnyPublisher<[ReceiptPosition], Never>,
        peopleService: PeopleService,
        divider: Divider,
        numberFormatter: NumberFormatter
    ) {
        self.peopleService = peopleService
        self.divider = divider
        self.numberFormatter = numberFormatter
        self.subscriptions = []
        self.divisionResult = .noDebt
        self.leftSidedBuyer = .empty
        self.rightSidedBuyer = .empty

        self.subscribe(to: positions)
        self.subscribe(to: peopleService.peopleDidUpdate)
    }

    private func subscribe(to positions: AnyPublisher<[ReceiptPosition], Never>) {
        func action(_ positions: [ReceiptPosition]) {
            divisionResult = divider.divide(positions)
        }
        positions.sink { action($0) }.store(in: &subscriptions)
    }

    private func subscribe(to peopleDidChange: AnyPublisher<[Person], Never>) {
        func action(_ people: [Person]) {
            precondition(people.count >= 2, "There must be at least 2 people.")
            leftSidedBuyer = people[0]
            rightSidedBuyer = people[1]
            objectWillChange.send()
        }
        peopleDidChange.sink { action($0) }.store(in: &subscriptions)
    }
}
