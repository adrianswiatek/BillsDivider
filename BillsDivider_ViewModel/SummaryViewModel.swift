import BillsDivider_Model
import Combine
import Foundation
import SwiftUI

public class SummaryViewModel: ObservableObject {
    private var divisionResult: DivisionResult
    private var sumResult: SumResult

    public var leftSidedBuyer: Buyer
    public var rightSidedBuyer: Buyer

    public var formattedSum: String {
        numberFormatter.format(value: sumResult.amount)
    }

    public var formattedDebt: String {
        numberFormatter.format(value: divisionResult.debtAmount)
    }

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
        self.sumResult = .zero
        self.leftSidedBuyer = .person(.empty)
        self.rightSidedBuyer = .person(.empty)

        self.subscribe(to: receiptPositionService.positionsDidUpdate)
        self.subscribe(to: peopleService.peopleDidUpdate)
    }

    public func name(for buyer: Buyer) -> String {
        buyer.formatted
    }

    public func color(for buyer: Buyer) -> Color {
        buyer.asPerson.colors.background.asColor
    }

    private func subscribe(to positionsDidUpdate: AnyPublisher<[ReceiptPosition], Never>) {
        positionsDidUpdate
            .sink { [weak self] in
                guard let self = self else { return }
                self.divisionResult = self.divider.divide($0, between: self.people)
                self.sumResult = .from(values: $0.map { $0.amountWithDiscount })
                self.objectWillChange.send()
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
